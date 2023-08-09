#!/bin/bash

set -euo pipefail

CICDURL="https://web.flymks.com/cicd/v6"
M1IP="${IP}"
JPATH="${HOME}/cicd/jenkins"
JYPATH="${JPATH}/jenkins.yaml"
TEMP_PATH="${JPATH}/temp.yaml"

save_file() {
    rm -rf "${JPATH}"
    mkdir -p "${JPATH}"; wget -q "${CICDURL}/ij.sh" -O "${JPATH}/ij.sh"
    wget -q "${CICDURL}/ah.zip" -O ~/cicd/ah.zip && unzip -o ~/cicd/ah.zip -d ~/cicd &>/dev/null
}

install_app() {
    curl -sSL -o "${JYPATH}" "${CICDURL}/jenkins.yaml"
    sed -i s"|192.168.1.211|${M1IP}|g" "${JYPATH}"
    sed '/env/a \ \ \ \ \ \ \ \ -\ name:\ JENKINS_ADMIN_PW\n\ \ \ \ \ \ \ \ \ \ value:\ cicdadmin' "${JYPATH}" > ${TEMP_PATH};
    sed '/env/a \ \ \ \ \ \ \ \ -\ name:\ JENKINS_ADMIN_ID\n\ \ \ \ \ \ \ \ \ \ value:\ admin' "${TEMP_PATH}" > ${JYPATH};
    rm -f ${TEMP_PATH};

    local namespace="jenkins"
    if ! kubectl get ns "${namespace}" &>/dev/null; then
        kubectl create ns "${namespace}"
    fi

    kubectl config set-context --current --namespace "${namespace}" &>/dev/null
    kubectl apply -f "${JYPATH}"
    kubectl rollout status deployment/jenkins-deployment
}

set_jenkins_url() {
    echo -n "wait jenkins setting..."

    jenkins_ip=$(kubectl get svc/jenkins --template="{{index .spec.externalIPs 0}}")
    jenkins_pod_name=$(kubectl get pod -l app=jenkins -o name)
    kubectl exec "${jenkins_pod_name}" -- /bin/bash -c "set-jenkins-url.sh ${jenkins_ip}"

    echo "ok"
    echo -e "Complete. You should be able to navigate to http://${jenkins_ip} in your browser now."
}

mv_data() {
mv alp.httpd/ ~/prod
mv ~/cicd/alp.httpd ~/prod
rm -rf ~/cicd
}

save_file
install_app
set_jenkins_url
mv_data
kubectl config set-context --current --namespace default &>/dev/null
[]bigred@m1:~/test$ cat aa.sh
#!/bin/bash

set -euo pipefail

CICDURL="https://web.flymks.com/cicd/v6"
M1IP="${IP}"
JPATH="${HOME}/cicd/jenkins"
JYPATH="${JPATH}/jenkins.yaml"
TEMP_PATH="${JPATH}/temp.yaml"

save_file() {
    rm -rf "${JPATH}"
    mkdir -p "${JPATH}"; wget -q "${CICDURL}/ij.sh" -O "${JPATH}/ij.sh"
    wget -q "${CICDURL}/ah.zip" -O ~/cicd/ah.zip && unzip -o ~/cicd/ah.zip -d ~/cicd &>/dev/null
}

install_app() {
    curl -sSL -o "${JYPATH}" "${CICDURL}/jenkins.yaml"
    sed -i s"|192.168.1.211|${M1IP}|g" "${JYPATH}"
    sed '/env/a \ \ \ \ \ \ \ \ -\ name:\ JENKINS_ADMIN_PW\n\ \ \ \ \ \ \ \ \ \ value:\ cicdadmin' "${JYPATH}" > ${TEMP_PATH};
    sed '/env/a \ \ \ \ \ \ \ \ -\ name:\ JENKINS_ADMIN_ID\n\ \ \ \ \ \ \ \ \ \ value:\ admin' "${TEMP_PATH}" > ${JYPATH};
    rm -f ${TEMP_PATH};

    local namespace="jenkins"
    if ! kubectl get ns "${namespace}" &>/dev/null; then
        kubectl create ns "${namespace}"
    fi

    kubectl config set-context --current --namespace "${namespace}" &>/dev/null
    kubectl apply -f "${JYPATH}"
    kubectl rollout status deployment/jenkins-deployment
}

set_jenkins_url() {
    echo -n "wait jenkins setting..."

    jenkins_ip=$(kubectl get svc/jenkins --template="{{index .spec.externalIPs 0}}")
    jenkins_pod_name=$(kubectl get pod -l app=jenkins -o name)
    kubectl exec "${jenkins_pod_name}" -- /bin/bash -c "set-jenkins-url.sh ${jenkins_ip}"

    echo "ok"
    echo -e "Complete. You should be able to navigate to http://${jenkins_ip} in your browser now."
}

mv_data() {
mv alp.httpd/ ~/prod
mv ~/cicd/alp.httpd ~/prod
rm -rf ~/cicd
}

save_file
install_app
set_jenkins_url
mv_data
kubectl config set-context --current --namespace default &>/dev/null
