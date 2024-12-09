from diagrams import Diagram, Edge, Cluster
from diagrams.gcp.analytics import Bigquery, Pubsub
from diagrams.gcp.compute import Run
from diagrams.gcp.storage import Storage
from diagrams.onprem.client import User
from diagrams.onprem.vcs import Github
from diagrams.onprem.ci import GithubActions
from diagrams.onprem.iac import Terraform
from diagrams.gcp.devtools import ContainerRegistry, Code
from diagrams.onprem.container import Docker


with Diagram("Arquitetura", direction="LR") as diag:
    user = User("Eu")
    outro_user = User("Outro usuário")
    git = Github("Github")
    bigquery = Bigquery("BigQuery")
    actions = GithubActions("Actions step 1")
    actions_step_2 = GithubActions("Actions step 2/3")
    code = Code("Código")
    docker = Docker("Docker")
    terraform = Terraform("")
    docker_registry = ContainerRegistry("Docker")
    cloud_run = Run("Cloud Run")
    modelo = Storage("Modelo")
    pubsub = Pubsub("PubSub")
    
    with Cluster("Life cycle (ciclo de vída) do código"):
        user >> code >> git >> actions
        actions >> actions_step_2 >> docker >> Edge(label="Imagem") >> docker_registry
        docker_registry >> Edge(label="Imagem") >> cloud_run
    
    with Cluster("Infraestrutura"):
        actions >> terraform
        terraform >> Edge(label="Criação da cloud run") >> cloud_run
        terraform >> Edge(label="Criação do docker registry") >> docker_registry
        terraform >> Edge(label="Criação do pubsub") >> pubsub
        terraform >> Edge(label="Criação do bigquery") >> bigquery
    
    with Cluster("Experiencia do usuário"):
        outro_user >> Edge(label="Chamada para o modelo") >> cloud_run >> Edge(label="Resultado") >> outro_user
    # actions >> docker
    # actions >> cloud_run
    
    # modelo >> cloud_run 
    # outro_user >> Edge(label="Chamada para o modelo") >> cloud_run >> Edge(label="Resultado") >> outro_user
    # cloud_run >> pubsub >> bigquery
    