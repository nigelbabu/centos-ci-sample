# CentOS CI Sample

This sample attempts to establish a pattern to use Centos CI with [JJB][jjb]
and python-cicoclient in a clean manner avoiding curl calls. This is from an
actual example we're using in [Gluster][gluster].

## How it works
### CICO environment variables
This leverages [python-cicoclient][cico] which provides an ansible module and
CLI client to consume the ephemeral bare metal provisioning infrastructure.

You need to set your ci.centos.org API key when connecting to the nodes as
environment variables on your slave node(s).

This is done in ``Managed Jenkins`` -> ``Managed Nodes`` -> <*node*> ->
``Configure`` -> ``Node properties`` -> ``Environment variables`` -> ``Add``:

```
name: CICO_API_KEY
value: <api key>
```

### Builder
To get the node, you include the get-node.sh script as a [shell
builder][shell]. This will use the python-cicoclient on the commandline to get
you nodes for your test. The hosts will be written to `$WORKSPACE/hosts` and the
ssid to `$WORKSPACE/cico-ssid` by default.

If you have more than one host, you may want to add an extra shell script to
convert the host file into an ansible host file.

### Publisher
To release the node, you need to use a [post-task][posttask]publisher. This way
even when the job fails, the nodes are released back into the pool. We match
the line "Building remotely" which should happen on every single job. This will
catch all failures and soft abort (clicking the x button in the UI once). This
will not run in a hard abort (clicking the x button in the UI twice).

# Credits
A lot of the scripts and patterns are thanks to [dmsimard][dmsimard] for the
[RDO Project][rdo].

[jjb]: http://docs.openstack.org/infra/jenkins-job-builder/
[gluster]: https://github.com/gluster/glusterfs-patch-acceptance-tests
[cico]: http://python-cicoclient.readthedocs.org/en/latest/
[shell]: http://docs.openstack.org/infra/jenkins-job-builder/builders.html#builders.shell
[posttask]: http://docs.openstack.org/infra/jenkins-job-builder/publishers.html#publishers.post-tasks
[rdo]: https://github.com/rdo-infra/ci-config
[dmsimard]: https://github.com/dmsimard
