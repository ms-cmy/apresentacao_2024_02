from diagrams import Diagram, Edge
from diagrams.gcp.analytics import Bigquery, Pubsub
from diagrams.gcp.compute import Run
from diagrams.gcp.storage import Storage
from diagrams.onprem.client import User
from diagrams.onprem.vcs import Github
from diagrams.onprem.ci import GithubActions
from diagrams.onprem.iac import Terraform
from diagrams.gcp.devtools import ContainerRegistry, Code
from diagrams.onprem.container import Docker


with Diagram("Arquitetura - Primeira parte - Life cycle do código", direction="LR") as diag:    
    user = User("Usuário")
    code = Code("Código")
    git = Github("Github")
    cloud_run = Run("Cloud Run")
    actions_step_2 = GithubActions("Github Actions (2/3)")
    terraform = Terraform("")
    actions = GithubActions("Github Actions")
    user >> code >> git >> actions
    actions >> terraform >> cloud_run
    terraform >> Pubsub("Pubsub")
    terraform >> Edge(label="Deploy da infraestrutura") >> Bigquery("Bigquery")
    terraform >> ContainerRegistry("Storage")
    actions >> actions_step_2


with Diagram("Arquitetura - Segunda parte - Deploy da aplicação", direction="LR") as diag:    
    user = User("Usuário")
    code = Code("Código")
    git = Github("Github")
    cloud_run = Run("Cloud Run")
    docker = Docker("Docker")
    actions_step_2 = GithubActions("Github Actions (2/3)")
    
    user >> code >> git >> actions_step_2 >> docker >> ContainerRegistry("Container registry") >> cloud_run
    
    cloud_run << Edge(label="Pega o nosso modelo de ML") << Storage("Storage")
    cloud_run >> Edge(label="Salva os dados no Bigquery") >> Pubsub("Pub sub") >> Bigquery("Bigquery")


with Diagram("Experiência do usuário", direction="LR") as diag:
    user = User("Usuário")
    cloud_run = Run("Cloud Run")
    bq = Bigquery("Bigquery")
    
    user >> Edge(label="Requisição '/'") >> cloud_run
    user >> Edge(label="Requisição '/predict'") >> cloud_run
    cloud_run >> Edge(label="Retorna a previsão") >> user
    cloud_run >> Edge(label="Salva os dados no Bigquery") >> bq
    
    