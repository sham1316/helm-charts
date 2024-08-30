# K8S gitopp repo struct

                     level0
  environment:       level1
    namespace:       level2
      service: {}    level3
  
example:

  common:
    cert-manager:
      cert-manager: {}
  
  develop-app1:
    develop-app1:
      microservice1: {}
      microservice2: {}

  stage-app1:
    stage-app1:
      microservice1: {}
      microservice2: {}
  


merge values level0 <- level1 <- level2 <- level3