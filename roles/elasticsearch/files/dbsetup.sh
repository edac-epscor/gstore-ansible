#!/bin/bash

curl -XPUT http://localhost:9200/gstore/

curl -XPUT 'http://localhost:9200/gstore/dataset/_mapping' -d '
{
     "dataset" : {
                "properties": {
                    "abstract": {
                        "type": "string"
                    },
                    "active": {
                        "type": "boolean"
                    },
                    "aliases": {
                        "type": "string",
                        "index_name": "alias"
                    },
                    "applications": {
                        "type": "string",
                        "index_name": "application"
                    },
                    "area": {
                        "type": "double"
                    },
                    "available": {
                        "type": "boolean"
                    },
                    "category": {
                        "properties": {
                            "apps": {
                                "type": "string"
                            },
                            "groupname": {
                                "type": "string"
                            },
                            "subtheme": {
                                "type": "string"
                            },
                            "theme": {
                                "type": "string"
                            }
                        }
                    },
                    "category_facets": {
                        "type": "nested",
                        "properties": {
                            "apps": {
                                "type": "string"
                            },
                            "groupname": {
                                "type": "string",
                                "index": "not_analyzed"
                            },
                            "subtheme": {
                                "type": "string",
                                "index": "not_analyzed"
                            },
                            "theme": {
                                "type": "string",
                                "index": "not_analyzed"
                            }
                        }
                    },
                    "collections": {
                        "type": "string"
                    },
                    "dataset": {
                        "properties": {
                            "abstract": {
                                "type": "string"
                            },
                            "active": {
                                "type": "boolean"
                            },
                            "applications": {
                                "type": "string"
                            },
                            "area": {
                                "type": "double"
                            },
                            "available": {
                                "type": "boolean"
                            },
                            "category": {
                                "properties": {
                                    "apps": {
                                        "type": "string"
                                    },
                                    "groupname": {
                                        "type": "string"
                                    },
                                    "subtheme": {
                                        "type": "string"
                                    },
                                    "theme": {
                                        "type": "string"
                                    }
                                }
                            },
                            "category_facets": {
                                "properties": {
                                    "apps": {
                                        "type": "string"
                                    },
                                    "groupname": {
                                        "type": "string"
                                    },
                                    "subtheme": {
                                        "type": "string"
                                    },
                                    "theme": {
                                        "type": "string"
                                    }
                                }
                            },
                            "date_added": {
                                "type": "date",
                                "format": "dateOptionalTime"
                            },
                            "date_published": {
                                "properties": {
                                    "date": {
                                        "type": "date",
                                        "format": "dateOptionalTime"
                                    },
                                    "day": {
                                        "type": "long"
                                    },
                                    "month": {
                                        "type": "long"
                                    },
                                    "year": {
                                        "type": "long"
                                    }
                                }
                            },
                            "embargo": {
                                "type": "boolean"
                            },
                            "formats": {
                                "type": "string"
                            },
                            "gstore_metadata": {
                                "properties": {
                                    "date": {
                                        "type": "date",
                                        "format": "dateOptionalTime"
                                    },
                                    "day": {
                                        "type": "long"
                                    },
                                    "month": {
                                        "type": "long"
                                    },
                                    "year": {
                                        "type": "long"
                                    }
                                }
                            },
                            "isotopic": {
                                "type": "string"
                            },
                            "keywords": {
                                "type": "string"
                            },
                            "location": {
                                "properties": {
                                    "bbox": {
                                        "properties": {
                                            "coordinates": {
                                                "type": "double"
                                            },
                                            "type": {
                                                "type": "string"
                                            }
                                        }
                                    }
                                }
                            },
                            "services": {
                                "type": "string"
                            },
                            "standards": {
                                "type": "string"
                            },
                            "taxonomy": {
                                "type": "string"
                            },
                            "title": {
                                "type": "string"
                            },
                            "title_search": {
                                "type": "string"
                            }
                        }
                    },
                    "date_added": {
                        "type": "date",
                        "format": "YYYY-MM-dd"
                    },
                    "date_published": {
                        "properties": {
                            "date": {
                                "type": "date",
                                "format": "YYYY-MM-dd"
                            },
                            "day": {
                                "type": "integer"
                            },
                            "month": {
                                "type": "integer"
                            },
                            "year": {
                                "type": "integer"
                            }
                        }
                    },
                    "embargo": {
                        "type": "boolean"
                    },
                    "formats": {
                        "type": "string"
                    },
                    "geomtype": {
                        "type": "string"
                    },
                    "gstore_metadata": {
                        "properties": {
                            "date": {
                                "type": "date",
                                "format": "YYYY-MM-dd"
                            },
                            "day": {
                                "type": "integer"
                            },
                            "month": {
                                "type": "integer"
                            },
                            "year": {
                                "type": "integer"
                            }
                        }
                    },
                    "isotopic": {
                        "type": "string"
                    },
                    "keywords": {
                        "type": "string"
                    },
                    "location": {
                        "properties": {
                            "bbox": {
                                "type": "geo_shape",
                                "tree": "quadtree",
                                "tree_levels": 40
                            },
                            "counties": {
                                "type": "string",
                                "index_name": "county"
                            },
                            "quads": {
                                "type": "string",
                                "index_name": "quad"
                            }
                        }
                    },
                    "model_run_name": {
                        "type": "string",
                        "index": "not_analyzed"
                    },
                    "model_vars": {
                        "type": "string"
                    },
                    "parent_model_run_uuid": {
                        "type": "string"
                    },
                    "repositories": {
                        "type": "string"
                    },
                    "services": {
                        "type": "string"
                    },
                    "standards": {
                        "type": "string",
                        "index": "not_analyzed"
                    },
                    "supported_repositories": {
                        "type": "nested",
                        "properties": {
                            "app": {
                                "type": "string"
                            },
                            "repos": {
                                "type": "string",
                                "index": "not_analyzed"
                            }
                        }
                    },
                    "taxonomy": {
                        "type": "string"
                    },
                    "model_run_uuid": {
                        "type": "string",
                        "index" : "not_analyzed"
                    },
                    "model_set":{
                        "type":"string",
                        "index":"not_analyzed"
                    },
                    "model_set_taxonomy":{
                        "type":"string",
                        "index":"not_analyzed"
                    },
                    "model_set_type":{
                        "type":"string",
                        "index":"not_analyzed"
                    },
                    "title": {
                        "type": "string"
                    },
                    "title_search": {
                        "type": "string",
                        "index": "not_analyzed"
                    },
                    "valid_end": {
                        "properties": {
                            "date": {
                                "type": "date",
                                "format": "YYYY-MM-dd HH:mm:ss"
                            },
                            "day": {
                                "type": "integer"
                            },
                            "month": {
                                "type": "integer"
                            },
                            "year": {
                                "type": "integer"
                            },
                            "hour": {
                                "type": "integer"
                            },
                            "minute": {
                                "type": "integer"
                            },
                            "second": {
                                "type": "integer"
                            }
                        }
                    },
                    "valid_start": {
                        "properties": {
                            "date": {
                                "type": "date",
                                "format": "YYYY-MM-dd HH:mm:ss"
                            },
                            "day": {
                                "type": "integer"
                            },
                            "month": {
                                "type": "integer"
                            },
                            "year": {
                                "type": "integer"
                            },
                            "hour": {
                                "type": "integer"
                            },
                            "minute": {
                                "type": "integer"
                            },
                            "second": {
                                "type": "integer"
                            }
                        }
                    }
                }
            }
}'

curl -XPUT 'http://localhost:9200/gstore/collection/_mapping' -d '
{
    "collection" : {
        "properties": {
            "abstract": {
                "type": "string"
            },
            "active": {
                "type": "boolean"
            },
            "applications": {
                "type": "string",
                "index_name": "application"
            },
            "area": {
                "type": "double"
            },
            "available": {
                "type": "boolean"
            },
            "category": {
                "properties": {
                    "apps": {
                        "type": "string"
                    },
                    "groupname": {
                        "type": "string"
                    },
                    "subtheme": {
                        "type": "string"
                    },
                    "theme": {
                        "type": "string"
                    }
                }
            },
            "category_facets": {
                "type": "nested",
                "properties": {
                    "apps": {
                        "type": "string"
                    },
                    "groupname": {
                        "type": "string",
                        "index": "not_analyzed",
                        "omit_norms": true,
                        "index_options": "docs"
                    },
                    "subtheme": {
                        "type": "string",
                        "index": "not_analyzed",
                        "omit_norms": true,
                        "index_options": "docs"
                    },
                    "theme": {
                        "type": "string",
                        "index": "not_analyzed",
                        "omit_norms": true,
                        "index_options": "docs"
                    }
                }
            },
            "date_added": {
                "type": "date",
                "format": "YYYY-MM-dd"
            },
            "embargo": {
                "type": "boolean"
            },
            "isotopic": {
                "type": "string"
            },
            "location": {
                "properties": {
                    "bbox": {
                        "type": "geo_shape",
                        "tree": "quadtree",
                        "tree_levels": 40
                    }
                }
            },
            "taxonomy": {
                "type": "string"
            },
            "model_run_uuid": {
                "type": "string",
                "index" : "not_analyzed"
            },
            "model_set":{
                "type":"string",
                "index":"not_analyzed"
            },
            "model_set_taxonomy":{
                "type":"string",
                "index":"not_analyzed"
            },
            "model_set_type":{
                "type":"string",
                "index":"not_analyzed"
            },
            "title": {
                "type": "string"
            }
        }
   }
}'
