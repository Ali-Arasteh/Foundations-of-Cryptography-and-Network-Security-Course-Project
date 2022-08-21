GUI();
%%
function GUI()
close all
if ~isfile('info.mat')
    InfoEncryptedUsername1 = string([]);
    InfoEncryptedSalt = string([]);
    InfoEncryptedUsername2 = string([]);
    InfoEncryptedData = string([]);
    save('info.mat','InfoEncryptedUsername1','InfoEncryptedSalt','InfoEncryptedUsername2','InfoEncryptedData');
end
info = load('info.mat');
Menu = questdlg('Select one of the below items:','Menu','Sign In','Login','Change Password','Sign In');
switch Menu
    case 'Sign In'
        SignInFlag = 1;
        while SignInFlag
            SignIn = inputdlg({'Username:','Password:'},'Sign in',[1 50]);
            if isempty(SignIn)
                SignInFlag = 0;
                GUI;
            else
                CharUsername = SignIn{1};
                CharPassword = SignIn{2};
                Hash1 = reshape(SHA_512(double(reshape(dec2bin(CharUsername,16)',1,[])-'0')),[4,128]);
                Key1 = xor(xor(xor(Hash1(1,:),Hash1(2,:)),Hash1(3,:)),Hash1(4,:));
                EncryptedUsername1 = AES_Encryption(double(reshape(dec2bin(CharUsername,16)',1,[])-'0'),Key1);
                EncryptedUsername1 = string(binaryVectorToHex(EncryptedUsername1));
                if isempty(CharUsername) || isempty(CharPassword)
                    disp('Username and Password fields must be filled');
                elseif isempty(find(info.InfoEncryptedUsername1 == EncryptedUsername1, 1))
                    SignInFlag = 0;
                    info.InfoEncryptedUsername1 = [info.InfoEncryptedUsername1;EncryptedUsername1];
                    Salt = round(rand(1,2048));
                    EncryptedSalt = AES_Encryption(Salt,Key1);
                    StringEncryptedSalt = string(binaryVectorToHex(EncryptedSalt));
                    info.InfoEncryptedSalt = [info.InfoEncryptedSalt;StringEncryptedSalt];
                    Hash2 = reshape(SHA_512([double(reshape(dec2bin([CharUsername,CharPassword],16)',1,[])-'0'),Salt]),[4,128]);
                    Key2 = xor(xor(xor(Hash2(1,:),Hash2(2,:)),Hash2(3,:)),Hash2(4,:));
                    EncryptedUsername2 = AES_Encryption(double(reshape(dec2bin(CharUsername,16)',1,[])-'0'),Key2);
                    EncryptedUsername2 = string(binaryVectorToHex(EncryptedUsername2));
                    info.InfoEncryptedUsername2 = [info.InfoEncryptedUsername2;EncryptedUsername2];
                    Data = [];
                    Data = AES_Encryption(Data,Key2);
                    EncryptedData = string(binaryVectorToHex(Data));
                    info.InfoEncryptedData = [info.InfoEncryptedData;EncryptedData];
                    InfoEncryptedUsername1 = info.InfoEncryptedUsername1;
                    InfoEncryptedSalt = info.InfoEncryptedSalt;
                    InfoEncryptedUsername2 = info.InfoEncryptedUsername2;
                    InfoEncryptedData = info.InfoEncryptedData;
                    save('info.mat','InfoEncryptedUsername1','InfoEncryptedSalt','InfoEncryptedUsername2','InfoEncryptedData');
                    fileID = fopen('Data.txt','w');
                    fclose(fileID);
                    LogoutFlag = 1;
                    while LogoutFlag
                        Logout = questdlg({'Use file Data.txt','Logout when you are done'},'Logout','Logout','Logout');
                        switch Logout
                            case 'Logout'
                                LogoutFlag = 0;
                                fileID = fopen('Data.txt','r');
                                Data = double(reshape(dec2bin(fread(fileID)',16)',1,[])-'0');
                                Data = AES_Encryption(Data,Key2);
                                EncryptedData = string(binaryVectorToHex(Data));
                                find(info.InfoEncryptedUsername1 == EncryptedUsername1, 1)
                                info.InfoEncryptedData(find(info.InfoEncryptedUsername1 == EncryptedUsername1, 1)) = EncryptedData;
                                InfoEncryptedUsername1 = info.InfoEncryptedUsername1;
                                InfoEncryptedSalt = info.InfoEncryptedSalt;
                                InfoEncryptedUsername2 = info.InfoEncryptedUsername2;
                                InfoEncryptedData = info.InfoEncryptedData;
                                save('info.mat','InfoEncryptedUsername1','InfoEncryptedSalt','InfoEncryptedUsername2','InfoEncryptedData');
                                fclose(fileID);
                                fileID = fopen('Data.txt','w');
                                fclose(fileID);
                        end
                    end
                    GUI;
                else
                    disp('This Username already has been used');
                end
            end
        end
    case 'Login'
        LoginFlag = 1;
        while LoginFlag
            Login = inputdlg({'Username:','Password:'},'Login',[1 50]);
            if isempty(Login)
                LoginFlag = 0;
                GUI;
            else
                CharUsername = Login{1};
                CharPassword = Login{2};
                Hash1 = reshape(SHA_512(double(reshape(dec2bin(CharUsername,16)',1,[])-'0')),[4,128]);
                Key1 = xor(xor(xor(Hash1(1,:),Hash1(2,:)),Hash1(3,:)),Hash1(4,:));
                EncryptedUsername1 = AES_Encryption(double(reshape(dec2bin(CharUsername,16)',1,[])-'0'),Key1);
                EncryptedUsername1 = string(binaryVectorToHex(EncryptedUsername1));
                if isempty(CharUsername) || isempty(CharPassword)
                    disp('The Username and Password fields must be filled');
                elseif ~isempty(find(info.InfoEncryptedUsername1 == EncryptedUsername1, 1))
                    LoginFlag = 0;
                    EncryptedSalt = info.InfoEncryptedSalt(find(info.InfoEncryptedUsername1 == EncryptedUsername1, 1),:);
                    Salt = AES_Decryption(hexToBinaryVector(EncryptedSalt,length(cast(EncryptedSalt,'char'))*4),Key1);
                    Hash2 = reshape(SHA_512([double(reshape(dec2bin([CharUsername,CharPassword],16)',1,[])-'0'),Salt]),[4,128]);
                    Key2 = xor(xor(xor(Hash2(1,:),Hash2(2,:)),Hash2(3,:)),Hash2(4,:));
                    EncryptedUsername2 = AES_Encryption(double(reshape(dec2bin(CharUsername,16)',1,[])-'0'),Key2);
                    EncryptedUsername2 = string(binaryVectorToHex(EncryptedUsername2));
                    if EncryptedUsername2 == info.InfoEncryptedUsername2(find(info.InfoEncryptedUsername1 == EncryptedUsername1, 1))
                        EncryptedData = info.InfoEncryptedData(find(info.InfoEncryptedUsername1 == EncryptedUsername1, 1));
                        Data = AES_Decryption(hexToBinaryVector(EncryptedData,length(cast(EncryptedData,'char'))*4),Key2);
                        if isempty(Data)
                            Data = '';
                        else
                            Data = cast(bi2de(flip(reshape(Data,16,[]))'),'char')';
                        end
                        fileID = fopen('Data.txt','w');
                        fwrite(fileID,Data);
                        fclose(fileID);
                        LogoutFlag = 1;
                        while LogoutFlag
                            Logout = questdlg({'Use file Data.txt','Logout when you are done'},'Logout','Logout','Logout');
                            switch Logout
                                case 'Logout'
                                    LogoutFlag = 0;
                                    fileID = fopen('Data.txt','r');
                                    Data = fread(fileID);
                                    fclose(fileID);
                                    Data = double(reshape(dec2bin(Data',16)',1,[])-'0');
                                    Data = AES_Encryption(Data,Key2);
                                    EncryptedData = string(binaryVectorToHex(Data));
                                    info.InfoEncryptedData(find(info.InfoEncryptedUsername1 == EncryptedUsername1, 1)) = EncryptedData;
                                    InfoEncryptedUsername1 = info.InfoEncryptedUsername1;
                                    InfoEncryptedSalt = info.InfoEncryptedSalt;
                                    InfoEncryptedUsername2 = info.InfoEncryptedUsername2;
                                    InfoEncryptedData = info.InfoEncryptedData;
                                    save('info.mat','InfoEncryptedUsername1','InfoEncryptedSalt','InfoEncryptedUsername2','InfoEncryptedData');
                                    fileID = fopen('Data.txt','w');
                                    fclose(fileID);
                            end
                        end
                    else
                        disp('Username or Password is incorrect'); 
                    end
                    GUI;
                else
                    disp('this Username does not exist');
                end
            end
        end
    case 'Change Password'
        ChangePasswordFlag = 1;
        while ChangePasswordFlag
            ChangePassword = inputdlg({'Username:','Previous Password:','New Password:'},'Change Password',[1 50]);
            if isempty(ChangePassword)
                ChangePasswordFlag = 0;
                GUI;
            else
                CharUsername = ChangePassword{1};
                CharPreviousPassword = ChangePassword{2};
                CharNewPassword = ChangePassword{3};
                Hash1 = reshape(SHA_512(double(reshape(dec2bin(CharUsername,16)',1,[])-'0')),[4,128]);
                Key1 = xor(xor(xor(Hash1(1,:),Hash1(2,:)),Hash1(3,:)),Hash1(4,:));
                EncryptedUsername1 = AES_Encryption(double(reshape(dec2bin(CharUsername,16)',1,[])-'0'),Key1);
                EncryptedUsername1 = string(binaryVectorToHex(EncryptedUsername1));
                if isempty(CharUsername) || isempty(CharPreviousPassword) || isempty(CharNewPassword)
                    disp('Username, Previous Password and New Password fields must be filled');
                elseif ~isempty(find(info.InfoEncryptedUsername1 == EncryptedUsername1, 1))
                    PreviousEncryptedSalt = info.InfoEncryptedSalt(find(info.InfoEncryptedUsername1 == EncryptedUsername1, 1),:);
                    PreviousSalt = AES_Decryption(hexToBinaryVector(PreviousEncryptedSalt,length(cast(PreviousEncryptedSalt,'char'))*4),Key1);
                    PreviousHash2 = reshape(SHA_512([double(reshape(dec2bin([CharUsername,CharPreviousPassword],16)',1,[])-'0'),PreviousSalt]),[4,128]);
                    PreviousKey2 = xor(xor(xor(PreviousHash2(1,:),PreviousHash2(2,:)),PreviousHash2(3,:)),PreviousHash2(4,:));
                    PreviousEncryptedUsername2 = AES_Encryption(double(reshape(dec2bin(CharUsername,16)',1,[])-'0'),PreviousKey2);
                    PreviousEncryptedUsername2 = string(binaryVectorToHex(PreviousEncryptedUsername2));
                    if PreviousEncryptedUsername2 == info.InfoEncryptedUsername2(find(info.InfoEncryptedUsername1 == EncryptedUsername1, 1))
                        ChangePasswordFlag = 0;
                        EncryptedData = info.InfoEncryptedData(find(info.InfoEncryptedUsername1 == EncryptedUsername1, 1));
                        EncryptedData = hexToBinaryVector(EncryptedData,length(cast(EncryptedData,'char'))*4);
                        Data = AES_Decryption(EncryptedData,PreviousKey2);
                        NewSalt = round(rand(1,2048));
                        NewEncryptedSalt = AES_Encryption(NewSalt,Key1);
                        StringNewEncryptedSalt = string(binaryVectorToHex(NewEncryptedSalt));
                        info.InfoEncryptedSalt(find(info.InfoEncryptedUsername1 == EncryptedUsername1, 1),:) = StringNewEncryptedSalt;
                        NewHash2 = reshape(SHA_512([double(reshape(dec2bin([CharUsername,CharNewPassword],16)',1,[])-'0'),NewSalt]),[4,128]);
                        NewKey2 = xor(xor(xor(NewHash2(1,:),NewHash2(2,:)),NewHash2(3,:)),NewHash2(4,:));
                        NewEncryptedUsername2 = AES_Encryption(double(reshape(dec2bin(CharUsername,16)',1,[])-'0'),NewKey2);
                        NewEncryptedUsername2 = string(binaryVectorToHex(NewEncryptedUsername2));
                        info.InfoEncryptedUsername2(find(info.InfoEncryptedUsername1 == EncryptedUsername1, 1),:) = NewEncryptedUsername2;
                        Data = AES_Encryption(Data,NewKey2);
                        NewEncryptedData = string(binaryVectorToHex(Data));
                        info.InfoEncryptedData(find(info.InfoEncryptedUsername1 == EncryptedUsername1, 1)) = NewEncryptedData;
                        InfoEncryptedUsername1 = info.InfoEncryptedUsername1;
                        InfoEncryptedSalt = info.InfoEncryptedSalt;
                        InfoEncryptedUsername2 = info.InfoEncryptedUsername2;
                        InfoEncryptedData = info.InfoEncryptedData;
                        save('info.mat','InfoEncryptedUsername1','InfoEncryptedSalt','InfoEncryptedUsername2','InfoEncryptedData');
                    else
                        disp('Username or Password is incorrect'); 
                    end
                    GUI;
                else
                    disp('This Username does not exist');
                end
            end
        end        
    otherwise
        disp('Good luck.')
end
end