var numInstances, newInstance;
with(argument[0]) {
    instance_destroy();
}
receiveCompleteMessage(global.serverSocket, 2, global.deserializeBuffer);
numInstances = fct_read_ushort(global.deserializeBuffer);
repeat(numInstances) {
    newInstance = instance_create(0,0,argument[0]);
    with(newInstance) {
        event_user(11);
    }
}
