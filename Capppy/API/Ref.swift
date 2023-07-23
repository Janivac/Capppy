//
//  Ref.swift
//  Capppy
//
//  Created by Jana Vac on 20.02.2023.
//

import Foundation
import Firebase
import FirebaseStorage

let REF_USER = "users"
let REF_MESSAGE =  "messages"
let REF_INBOX = "inbox"
let REF_ACTION = "action"

let URL_STORAGE_ROOT = "gs://uznevim-40271.appspot.com/"
let STORAGE_PROFILE = "profile"
let PROFILE_IMAGE_URL="profileImageUrl"

let UID = "uid"
let EMAIL = "email"
let USERNAME = "username"
let STATUS = "status"
let IS_ONLINE = "isOnline"
let ERROR_EMPTY_PHOTO = "Avatar je prázdný"
let ERROR_EMPTY_EMAIL = "Email je prázdný"
let ERROR_EMPTY_USERNAME = "Jméno je prázdné"
let ERROR_EMPTY_PASSWORD = "Heslo je prázdné"
let ERROR_EMPTY_EMAIL_RESET = "Prosím, vlož email pro obnovení hesla"
let SUCCESS_EMAIL_RESET = "Na email Vám bylo zaslánováno resetování hesla"
let ERROR_INCFORM_EMAIL = "Email je v nesprávném tvaru"
let ERROR_INCFORM_PASSWORD = "Heslo musí obsahovat alespoň 8 znaků, včetně velkých a malých písmen a čísel. Zkuste prosím jiné heslo nebo přidejte další znaky"
let ERROR_INCFORM_USERNAME = "Křestní jméno musí obsahovat alespoň 3 písmena bez mezer, znaků a číslic"
let ERROR_NOREG_EMAIL = "Email není registrovaný"
let ERROR_ALREG_EMAIL = "Email již používá někdo jiný"
let ERROR_NOT_VALID = "Přihlašovací údaje nejsou správné"
let ZKOUSKA = "Jednorožec"
let ERROR_PERMISSIONS = "Nemáte dostatečná oprávnění"
let ERROR_LOGIN_AGAIN = "Jedná se o citlivou akci, pro odstranění účtu se odhlašte a znovu přihlašte."


let IDENTIFIER_TABBAR = "TabBarVC"
let IDENTIFIER_WELCOME = "WelcomeVC"
let IDENTIFIER_CHAT = "ChatVC"
let IDENTIFIER_USER_AROUND = "UsersAroundViewController"
let IDENTIFIER_DETAIL = "DetailViewController"
let IDENTIFIER_RADAR = "RadarViewController"
let IDENTIFIER_NEW_MATCH = "NewMatchTableViewController"



let IDENTIFIER_CELL_USERS = "UserTableViewCell"


class Ref {
    let databaseRoot: DatabaseReference = Database.database().reference()
    
    var databaseUsers: DatabaseReference {
        return databaseRoot.child(REF_USER)
    }
    
    func databaseSpecificUser(uid: String) -> DatabaseReference {
        return databaseUsers.child(uid)
    }
    
    func databaseIsOnline(uid: String) -> DatabaseReference{
        return databaseUsers.child(uid).child(IS_ONLINE)
    }
    
    var databaseMessage: DatabaseReference {
        return databaseRoot.child(REF_MESSAGE)
    }
    
    var databaseAction: DatabaseReference {
        return databaseRoot.child(REF_ACTION)
    }
    
    func databaseActionForUser(uid: String) -> DatabaseReference {
        return databaseAction.child(uid)
    }
    
    func databaseMessageSendTo(from: String, to: String) -> DatabaseReference {
        return databaseMessage.child(from).child(to)
    }
    
    var databaseInbox: DatabaseReference {
        return databaseRoot.child(REF_INBOX)
    }
    
    func databaseInboxInfor(from: String, to: String) -> DatabaseReference {
        return databaseInbox.child(from).child(to)
    }
    
    func databaseInboxForUser(uid: String) -> DatabaseReference{
        return databaseInbox.child(uid)
    }
    
    // Storage Ref
    
    let storageRoot = Storage.storage().reference(forURL: URL_STORAGE_ROOT)
    
    var storageMessage: StorageReference {
        return storageRoot.child(REF_MESSAGE)
    }
    
    var storageProfile: StorageReference {
        return storageRoot.child(STORAGE_PROFILE)
    }
    
    func storageSpecificProfile(uid: String) -> StorageReference {
        return storageProfile.child(uid)
    }
    
    func storageSpecificImageMessage(id: String) -> StorageReference {
        return storageMessage.child("photo").child(id)
    }
    
    func storageSpecificVideoMessage(id: String) -> StorageReference {
        return storageMessage.child("video").child(id)
    }
    
    
    
}
