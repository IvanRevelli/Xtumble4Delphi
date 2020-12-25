unit xtServiceAddress;


interface

type
(*  TxtServices = class
    type TMyEnum = (myValue1, myValue2, myValue3, myValue4);
    const
         MyStrVals: array [TMyEnum] of string =
      ('One', 'Two', 'Three', 'Four');
          MyIntVals: array [TMyEnum] of integer =
      (1, 2, 3, 4);
  end; *)


  TxtServices = class
    type TMyEnum = (myValue1, myValue2, myValue3, myValue4);
    const
      validateAccount   = 'ValidateAccount';
      registeraccount   = 'registeraccount';
      jdataset          = 'jdataset';
      entitypk          = 'entitypk';
      uploadAttachment  = 'UploadAttachment';
      getWebAlias       = 'getwebalias';
      setWebAlias       = 'setwebalias';
      mailout           = 'mailout';
      uploadrawtemplate = 'uploadrawtemplate';
      downloadtemplate  = 'downloadreporttemplate';
      buildcustomweb     = 'buildcustomweb';
      customizewebfile   = 'customizewebfile';
      DownloadAttachment = 'DownloadAttachment';
      DownloadAttachmentPub = 'downloadattachmentpub';
  end;


implementation

end.
