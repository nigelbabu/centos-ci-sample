# Inspired by cico-node-get-to-ansible.sh
# A script that provisions nodes and writes them to a file
NODE_COUNT=${NODE_COUNT:-1}
HOST_FILE=${HOST_FILE:-$WORKSPACE/hosts}
SSID_FILE=${SSID_FILE:-$WORKSPACE/cico-ssid}

# Delete the host file if it exists
rm -rf $HOST_FILE

# Get nodes
nodes=$(cico -q node get --count ${NODE_COUNT} --column hostname --column ip_address --column comment -f value)

# Write nodes to inventory file and persist the SSID separately for simplicity
touch ${SSID_FILE}
IFS=$'\n'
for node in ${nodes}
do
    host=$(echo "${node}" |cut -f1 -d " ")
    address=$(echo "${node}" |cut -f2 -d " ")
    ssid=$(echo "${node}" |cut -f3 -d " ")

    line="${address}"
    echo "${line}" >> ${HOST_FILE}

    # Write unique SSIDs to the SSID file
    if ! grep -q ${ssid} ${SSID_FILE}; then
        echo ${ssid} >> ${SSID_FILE}
    fi
done
