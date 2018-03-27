#!/opt/modwsgi/gstore_v3_env/bin/python

import os
import glob
import json
from lxml import etree
import requests
import sys
from datetime import datetime
import pytz
from osgeo import ogr, osr

'''
Generic gstore import script 

'''


INSERT_DATASET_URL = 'http://localhost/gstore_v3/apps/gstore/datasets'

APP_KEY = 'gstore'
INSERT_ATTRIBUTES_URL = 'http://localhost/gstore_v3/apps/%(app)s/datasets/%(uuid)s/attributes'
INSERT_GEOMETRIES_URL = 'http://localhost/gstore_v3/apps/%(app)s/datasets/%(uuid)s/features'
INSERT_FEATURES_URL = 'http://localhost/gstore_v3/apps/%(app)s/datasets/%(uuid)s/featureattributes'
UPDATE_DATASET_URL = 'http://localhost/gstore_v3/apps/%(app)s/datasets/%(uuid)s'


json_files = glob.glob('/geodata/sample_datasets/jsons/*.json')



for json_file in json_files:
    print 'PROCESSING: ', json_file
    with open(json_file, 'r') as f:
        post_data = json.loads(f.read())

    # get the metadata path from the json
    # make sure the xml is properly encoded
    # before replacing the link with the xml (as string)
    xml = etree.parse(post_data['metadata']['xml'])
    post_data['metadata']['xml'] = etree.tostring(xml, encoding=unicode)

    apps = post_data['apps']

    if len(apps) > 1:
        the_url = INSERT_DATASET_URL % {'app': apps[0]}
        post_data.update({"apps": apps[1:]})
    else:
        the_url = INSERT_DATASET_URL % {'app': apps[0]}
        post_data.update({"apps": []})

    post_data['active'] = 'true'

    # post the dataset
    result = requests.post(INSERT_DATASET_URL, data=json.dumps(post_data))
    if result.status_code != 200:
        print '\tFAILED INSERT', result.status_code
        print '\t', result.content
        continue

    # the uuid to the new dataset
    new_dataset = result.content
    print '\tDATASET INSERTED: ', new_dataset

    # save this uuid, mostly for the vector/table inserts, for
    # additional processing
    with open(os.path.join('/geodata/sample_datasets/logs/dataset_insert', json_file.split('/')[-1].replace('.json', '_rsp.json')), 'w') as f:
        f.write('{"dataset_uuid": "%s"}' % new_dataset)


NODATA = '-9999'

insert_dataset_log = '/geodata/sample_datasets/logs/dataset_insert/wilderness2014_rsp.json'
shapefile_to_convert = '/geodata/sample_datasets/data/nlcs_wilderness_areas_2014.shp'


def epsg_to_sr(epsg):
    sr = osr.SpatialReference()
    sr.ImportFromEPSG(epsg)
    return sr


def reproject_geom(geom, in_sr, out_sr):
    geom.AssignSpatialReference(in_sr)
    try:
        geom.TransformTo(out_sr)
    except:
        print "error"


OUTPUT_SR = epsg_to_sr(4326)

print "Convert " + shapefile_to_convert+" to GSToRE vector"

# get the dataset uuid from the insert log
with open(insert_dataset_log, 'r') as f:
    dataset_log = json.loads(f.read())
dataset_uuid = dataset_log['dataset_uuid']

# handle the shapefile
shpfile = ogr.Open(shapefile_to_convert)
layer = shpfile.GetLayer()


'''
build a generic attribute dict
'''
layer_defs = layer.GetLayerDefn()
num_fields = layer_defs.GetFieldCount()
fields = [layer_defs.GetFieldDefn(i).GetNameRef() for i in range(num_fields)]
attributes = [{'orig_name': layer_defs.GetFieldDefn(i).GetNameRef(),
               'name': layer_defs.GetFieldDefn(i).GetNameRef(),
               'ogr_type': layer_defs.GetFieldDefn(i).GetType(),
               'description': '',
               'ogr_width': layer_defs.GetFieldDefn(i).GetWidth(),
               'ogr_precision': layer_defs.GetFieldDefn(i).GetPrecision(),
               'ogr_justify': layer_defs.GetFieldDefn(i).GetJustify(),
               'nodata': NODATA} for i in range(num_fields)]

attribute_data = {'dataset': dataset_uuid, 'fields': attributes}

'''
convert all of the geometries to wgs84 wkb
'''
layer_spref = layer.GetSpatialRef()
geometries = []
for i in xrange(layer.GetFeatureCount()):
    feature = layer.GetFeature(i)

    geometry = feature.GetGeometryRef()

    if OUTPUT_SR != layer_spref:
        try:
            reproject_geom(geometry, layer_spref, OUTPUT_SR)
        except Exception as err:
            print err
            sys.exit()

    geometries.append(
        {"gid": feature.GetFID(), "geom": geometry.ExportToWkb().encode('hex')})

'''
post the attributes and geometries
'''
print '\tposting attributes'
result = requests.post(INSERT_ATTRIBUTES_URL % {
                       'app': APP_KEY, 'uuid': dataset_uuid}, data=json.dumps(attribute_data))
if result.status_code != 200:
    print result.status_code, result.content
    sys.exit()
with open(os.path.join('/geodata/sample_datasets/logs/attribute_insert', insert_dataset_log.split('/')[-1]), 'w') as f:
    f.write(result.content)
attributes_rsp = json.loads(result.content)['attributes']

print '\tposting geometries'
geometries_rsp = {}
for geom in geometries:
    result = requests.post(INSERT_GEOMETRIES_URL % {
                           'app': APP_KEY, 'uuid': dataset_uuid}, data=json.dumps(geom))
    if result.status_code != 200:
        print result.status_code, result.content
        sys.exit()
    geometries_rsp[geom['gid']] = json.loads(result.content)
with open(os.path.join('/geodata/sample_datasets/logs/geometry_insert', insert_dataset_log.split('/')[-1]), 'w') as f:
    f.write(json.dumps(geometries_rsp, indent=4))


'''
build the feature dict based on the cells, the attribute response and the geometry response
'''
print '\tbuilding features'
features = []
for i in xrange(layer.GetFeatureCount()):
    feature = layer.GetFeature(i)
    feature_id = feature.GetFID()

    '''
    if the dataset has a timestamp to be used for searches,
    you would include the normalization to utc here.
    
    and include the utc timestamp ('%Y%m%dT%H:%M:%S') as
    'observed' in the dict for the feature
    '''

    geom = geometries_rsp[feature_id] if feature_id in geometries_rsp else ''
    if not geom:
        print 'missing geometry: ', feature_id
        sys.exit()

    # get the shapes info
    gid = geom['gid']
    fid = geom['fid']
    f_uuid = geom['uuid']

    atts = []
    for field in fields:
        val = feature.GetField(field)

        attr = [a for a in attributes_rsp if a['name'] == field]
        if not attr:
            print 'missing attribute: ', field
            sys.exit()
        attr = attr[0]

        # at least try to get the data type right
        try:
            if not val:
                val = NODATA
            elif attr['ogr_type'] == ogr.OFTInteger:
                val = int(val)
            elif attr['ogr_type'] == ogr.OFTReal:
                val = float(val)
            else:
                val = unicode(val, 'utf8')
        except:
            try:
                val = unicode(val, 'latin-1')
            except:
                val = NODATA

        atts.append({"name": field, "u": str(attr['uuid']), "val": val})

    features.append({"uuid": str(f_uuid), "fid": fid, "atts": atts})
with open(os.path.join('/geodata/sample_datasets/logs/feature_insert', insert_dataset_log.split('/')[-1]).replace('_rsp', ''), 'w') as f:
    f.write(json.dumps({"records": features}, indent=4))

'''
post the features
'''

print '\tposting features'
result = requests.post(INSERT_FEATURES_URL % {
                       'app': APP_KEY, 'uuid': dataset_uuid}, data=json.dumps({"records": features}))
if result.status_code != 200:
    print result.content
    sys.exit()
with open(os.path.join('/geodata/sample_datasets/logs/feature_insert', insert_dataset_log.split('/')[-1]), 'w') as f:
    f.write(result.content)


'''
update the dataset from FILE to VECTOR
alternately, the dataset can be added as a vector, but inactive.
after running this process, UPDATE the dataset to active. the 
features are transferred between the inactive collection to the
active collection.
'''
print '\tupdating dataset'
update_data = {
    "taxonomy": {"taxonomy": "vector", "geomtype": "POLYGON"},
    "formats": ['zip', 'shp', 'gml', 'kml', 'csv', 'xls', 'json', 'geojson'],
    "services": ['wms', 'wfs'],
    "features": layer.GetFeatureCount()
}
result = requests.post(UPDATE_DATASET_URL % {
                       'app': APP_KEY, 'uuid': dataset_uuid}, data=json.dumps(update_data))
if result.status_code != 200:
    print ''
    sys.exit()

print 'VECTOR CONVERSION COMPLETE'
