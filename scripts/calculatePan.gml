{
    var xmid;
    xmid = view_xview[0] + view_wview[0]/2;
    
    if((argument[0]-xmid)<-400) {
        return -1;
    } else if((argument[0]-xmid)>400) {
        return 1;
    } else {
        return ((argument[0]-xmid)/400);
    }
}
