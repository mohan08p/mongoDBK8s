kubectl exec -it mongo-0 -- mongo

rs.initiate()

var cfg = rs.conf()

# Add a first(primary) member to replica set
cfg.members[0].host="mongo-0.mongo:27017"

rs.reconfig(cfg)

rs.status()

rs.add("mongo-1.mongo:27017")

rs.add("mongo-2.mongo:27017")

rs.status()

## Connection string
#mongo mongodb://mongo-0.mongo:27017,mongo-1.mongo:27017,mongo-2.mongo:27017/admin?replicaSet=rs0