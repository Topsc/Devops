var AWS= require("aws-sdk");
exports.handler=(event,context, callback)=>{
    var s3=new AWS.S3();
    var sourceBucket="techscrum-linda-frontend";
    var destinationBucket="techscrum-s3-backup-serverless";
    var request = JSON.parse(event.body);
    var objectKey=request.Records[0].s3.object.key;
    var copySource=encodeURI(sourceBucket+"/"+objectKey);
    var copyParams= {Bucket: destinationBucket, CopySource: copySource, Key: objectKey};
    s3.copyObject(copyParams,function(err,data){
        if(err)
        {
            console.log(err,err.stack);
        }
        else
        {
            console.log("s3 copied successed");

        }
    });
    var response = {
            "statusCode": 200,
            "headers": {
                "my_header": "my_value"
            },
            "body": JSON.stringify({message:"successed"}),
            "isBase64Encoded": false
            };
    callback(null, response);
}