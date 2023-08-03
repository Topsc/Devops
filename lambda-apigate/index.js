var AWS= require("aws-sdk");
exports.handler=(event,context,callback)=>{
    var s3=new AWS.S3();
    var sourceBucket="techscrum-fe-20230720110018678400000002";
    var destinationBucket="techscrum-backup";
    var objectKey=event.Records[0].s3.object.key;
    var copySource=encodeURI(sourceBucket+"/"+objectKey);
    var copyParams= {Bucket: destinationBucket, CopySource: copySource, Key: objectKey};
    s3.copyObject(copyParams,function(err,data){
        if(err)
        {
            console.log(err,err.stack);
        }
        else
        console.log("S3 object copied successfully");
    });
}