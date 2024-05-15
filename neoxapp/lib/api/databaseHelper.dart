import 'dart:developer';
import 'dart:io';

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:neoxapp/model/chat_data_model.dart';
import 'package:neoxapp/model/restore_data_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../model/sidebar_Restore.dart';
import '../model/user_group_message_model.dart';
import '../presentation/controller/new_message_controller.dart';

class DatabaseHelper {
  DatabaseHelper._();

  static final DatabaseHelper db = DatabaseHelper._();
}

Database? chat;

Future<Database?> get initDatabase async {
  // print('vital db ${chat}');
  if (chat != null) {
    return chat;
  }

  chat = await initDB();
  return chat;
}

// deleteDatabase() async {
//   Directory documentsDirectory = await getApplicationDocumentsDirectory();
//   String path = join(documentsDirectory.path, "chatDatabase.db");
//   databaseFactory.deleteDatabase(path);
// }

initDB() async {
  Directory documentsDirectory = await getApplicationDocumentsDirectory();
  String path = join(documentsDirectory.path, "chatDatabase.db");
  return await openDatabase(path, version: 1, onOpen: (db) {
    log("DB OPEN");
  }, onCreate: _onCreate);
}

_onCreate(Database db, int version) async {
  log("DB Created");

  await db.execute('''
        CREATE TABLE Conversation(
        id TEXT PRIMARY KEY,
        conversation_id TEXT,
        sender_id TEXT, 
        receiver_id TEXT, 
        FileOriginalName TEXT, 
        message TEXT, 
        message_type NUMBER, 
        media_type NUMBER,
        delivery_type NUMBER,
        reply_message_id TEXT)
        ''');

  await db.execute('''
        CREATE TABLE RestoreDataModel(
        id TEXT PRIMARY KEY,
        success NUMBER,
        userChatDataLength NUMBER, 
        UserGroupChatDataLength NUMBER)
''');

  await db.execute('''
        CREATE TABLE GroupDetails(
        id TEXT PRIMARY KEY,
        cid NUMBER,
        group_id NUMBER, 
        member_id NUMBER,
        user_image TEXT,
        first_name TEXT,
        last_name TEXT,
        is_admin NUMBER,
        createdAt TEXT,
        updatedAt TEXT
        )
''');

  await db.execute('''
        CREATE TABLE RestoreSideBarData(
        _id TEXT PRIMARY KEY,
        last_message TEXT,
        cid TEXT, 
        last_media_type NUMBER, 
        createdAt TEXT, 
        block_by NUMBER, 
        user_extension TEXT, 
        isGroup NUMBER, 
        isReported NUMBER, 
        isBlocked NUMBER, 
        istyping NUMBER, 
        is_online NUMBER, 
        isblocked_by_reciver NUMBER, 
        last_seen TEXT, 
        mute_type NUMBER, 
        ismute NUMBER, 
        name TEXT, 
        description TEXT, 
        image TEXT, 
        last_message_time TEXT, 
        unread_msg_count NUMBER, 
        pintime TEXT, 
        ispin NUMBER,
        ismember NUMBER,
        isAdmin NUMBER)
''');

  await db.execute('''
        CREATE TABLE RestoreUserChatData(
        _id TEXT PRIMARY KEY,
        MSG_ID TEXT,
        broadcast_id TEXT,
        broadcast_msg_id TEXT, 
        originalName TEXT, 
        message TEXT, 
        message_caption TEXT, 
        filePath TEXT, 
        message_type NUMBER, 
        media_type NUMBER, 
        is_edited NUMBER, 
        delivery_type NUMBER, 
        reply_message_id TEXT, 
        schedule_time TEXT, 
        senderFirstName TEXT, 
        senderLastName TEXT, 
        block_message_users TEXT, 
        delete_message_users TEXT, 
        is_deleted NUMBER, 
        message_reaction_users TEXT, 
        message_dissapear_time TEXT, 
        group_id TEXT, 
        cid TEXT, 
        sender_id TEXT, 
        receiver_id TEXT, 
        createdAt TEXT, 
        __v NUMBER, 
        updatedAt TEXT)
''');

  await db.execute('''
        CREATE TABLE RestoreUserGroupChatData(
        _id TEXT PRIMARY KEY,
        MSG_ID TEXT,
        originalName TEXT,
        message TEXT, 
        message_caption TEXT, 
        message_type NUMBER,
         filePath TEXT,  
        media_type NUMBER,
        is_edited NUMBER, 
        delivery_type NUMBER, 
        reply_message_id TEXT, 
        schedule_time NUMBER, 
        block_message_users TEXT, 
        delete_message_users TEXT, 
        is_deleted NUMBER, 
        message_reaction_users TEXT, 
        message_dissapear_time TEXT, 
        cid TEXT, 
        group_id TEXT, 
        sender_id TEXT, 
        createdAt TEXT, 
        updatedAt TEXT, 
        __v NUMBER)
''');

  await db.execute('''
        CREATE TABLE group_members(
        id TEXT PRIMARY KEY,
         group_id TEXT,
        member_id TEXT,
        is_admin NUMBER)
        ''');

  await db.execute('''
        CREATE TABLE group_message_status(
        id TEXT PRIMARY KEY,
         group_id TEXT,
        message_id TEXT,
        sender_id TEXT,
        receiver_id TEXT,
        delivery_time TEXT,
        read_time TEXT,
        delivery_type NUMBER)
        ''');

  await db.execute('''
        CREATE TABLE conversation_list(
        id TEXT PRIMARY KEY,
         isGroup TEXT,
        last_message TEXT,
        last_message_type NUMBER,
        conversation_time TEXT,
        conversation_id NUMBER,
        name TEXT,
        unread_count NUMBER,
        profile TEXT,
        is_pin NUMBER,
        is_notification_mute TEXT,
        is_message_only_admin TEXT,
        is_block TEXT,
        is_exited TEXT)
        ''');
}

//================  INSERT DATA =================//
insert_Conversation() async {
  final db = await initDatabase;
  return db?.rawQuery("insert into Conversation("
      "id,"
      "conversation_id,"
      "sender_id,"
      "receiver_id,"
      "FileOriginalName,"
      "message,"
      "message_type,"
      "media_type,"
      "delivery_type,"
      "reply_message_id,"
      "values('1','0','0','0','Gaurav','Hello',1,1,0,'0')");
}

insert_RestoreData() async {
  final db = await initDatabase;
}

insert_group_members() async {
  final db = await initDatabase;
  return db?.rawQuery('''
  insert into group_members(id,group_id,member_id,is_admin)
  values('0','0','0',0)
  ''');
}

insert_group_message_status() async {
  final db = await initDatabase;
  return db?.rawQuery('''
    insert into group_message_status(id,group_id,message_id,sender_id,receiver_id,delivery_time,read_time,delivery_type)
    values('0','0','0','0','0','10:14,11-01-1024','10:14,11-01-1024',1)
    ''');
}

insert_conversation_list() async {
  final db = await initDatabase;
  return db?.rawQuery('''
    insert into conversation_list(id,isGroup, last_message,last_message_type,conversation_time,conversation_id,name,unread_count,profile,is_pin, is_notification_mute TEXT,
        is_message_only_admin,
        is_block,
        is_exited)
    values('0','0','0',0,'0',0,'0',0,'0',0,'0','0','0','0')
    ''');
}

insertRestoreData(Map<String, dynamic> data) async {
  final db = await initDatabase;
  db?.insert("RestoreDataModel", data);
}

insertSideBarRestoreData(List<Map<String, dynamic>> data) async {
  final db = await initDatabase;
  for (var element in data) {
    SideBarDatum sideBarDatum = SideBarDatum.fromJson(element);
    await db?.insert("RestoreSideBarData", sideBarDatum.toJson()).then((value) {});
  }
}

deleteDb() async {
  final db = await initDatabase;
  await db?.delete("RestoreDataModel");
  await db?.delete("RestoreSideBarData");
  await db?.delete("RestoreDataModel");
  await db?.delete("RestoreUserChatData");
  await db?.delete("RestoreUserGroupChatData");
}

insertUserChatDataRestoreData(List<Map<String, dynamic>> data) async {
  final db = await initDatabase;

  for (var element in data) {
    ChatDataModel chatDataModel = ChatDataModel.fromJson(element);
// if(chatDataModel.deliveryType==1){
//   socket.sendDeliveryStatus(chatDataModel.groupId==null?0:1, chatDataModel.groupId !=null  ?chatDataModel. groupId : null, chatDataModel.id,  2);
// }

    chatDataModel.MSG_ID = chatDataModel.id;
    try {
      // int? i = await db?.insert("RestoreUserChatData", chatDataModel.toJson());
      print("insert===0000==");
    } catch (ex) {
      print("Correctly crashed on SQLITE_CONSTRAINT_FOREIGNKEY");
    }
  }
}

updateUserChatDataRestoreData(String path, String id, isGroup) async {
  final db = await initDatabase;
  await db?.update(isGroup ? "RestoreUserGroupChatData" : "RestoreUserChatData", {"filePath": path}, where: "_id=?", whereArgs: [id]);
}

updateUserChatDataFullRestoreData(String? url, String id) async {
  final db = await initDatabase;
  await db?.update("RestoreUserChatData", {"message": url}, where: "_id=?", whereArgs: [id]);
}

updateUserGroupChatDataRestoreData(String path, String id) async {
  final db = await initDatabase;
  await db?.update("RestoreUserGroupChatData", {"filePath": path}, where: "_id=?", whereArgs: [id]);
}

updateUserDataGroupChatDataRestoreData(Map<String, dynamic> data, String id) async {
  final db = await initDatabase;
  await db?.update("RestoreUserGroupChatData", data, where: "_id=?", whereArgs: [id]);
}

insertRestoreUserGroupChatData(List<Map<String, dynamic>> data) async {
  print("insert=== group === ----------");

  final db = await initDatabase;
  for (var element in data) {
    // print("insert= 5555555 == group === ----------");

    UserGroupChatDataModel model = UserGroupChatDataModel.fromJson(element);
    model.MSG_ID = model.id;
    // if(model.deliveryType==1){
    //   socket.sendDeliveryStatus(model.groupId==null?0:1, model.groupId !=null  ?model. groupId : null, model.id,  2);
    // }

    try {
      int? i = await db?.insert("RestoreUserGroupChatData", model.toJson());
      print("insert=== group ${i}");
    } catch (ex) {
      print("insert= 5555555 == group === ----------${ex}");
    }
  }
}

deleteRestoreUserGroupChatData() async {
  final db = await initDatabase;

  db?.delete("RestoreUserGroupChatData");
}

updateSideBarRestoreData(id, online, lastseen) async {
  final db = await initDatabase;
  db?.update("RestoreSideBarData", {"is_online": online, "last_seen": lastseen}, where: "_id=?", whereArgs: [id]);
}

updateSideBarGroupData(id, name, image) async {
  final db = await initDatabase;
  int i = await db?.update("RestoreSideBarData", {"name": name, "image": image}, where: "_id=?", whereArgs: [id]) ?? -1;
  var v = await db?.query("RestoreSideBarData", where: "_id=?", whereArgs: [id]);

  if (v == null || v.isEmpty) {
    return;
  }
  NewMessagesController newMessagesController = Get.find();
  newMessagesController.setSideBarData(SideBarData.fromJson(v.first));

  // print("objecti-==$v");
}
//=============== GET DATA =================//

getRestoreData() async {
  final db = await initDatabase;
  return db?.query("RestoreDataModel");
}

getRestoreSideBarData() async {
  final db = await initDatabase;
  return db?.query("RestoreSideBarData", orderBy: 'last_message_time DESC');
}

getRestoreUserChatData() async {
  final db = await initDatabase;
  return db?.query("RestoreUserChatData", orderBy: 'createdAt DESC');
}

getRestoreUserGroupChatData() async {
  final db = await initDatabase;
  return db?.query(
    "RestoreUserGroupChatData",
  );
}

//================  DELETE DATA ===========//

delete_Single_Message(id) async {
  final db = await initDatabase;
  return db?.delete("Conversation", where: "id=?", whereArgs: [id]);
}

delete_All_Conversation(id) async {
  final db = await initDatabase;
  return db?.delete("Conversation", where: "conversation_id=?", whereArgs: [id]);
}

delete_group_member(group_id, member_id) async {
  final db = await initDatabase;
  return db?.delete("group_members", where: "group_id=? AND member_id=?", whereArgs: [group_id, member_id]);
}

delete_group_message_status(group_id, member_id) async {
  final db = await initDatabase;
  return db?.delete("group_message_status", where: "group_id=? AND member_id=?", whereArgs: [group_id, member_id]);
}

delete_conversation_list(group_id, member_id) async {
  final db = await initDatabase;
  return db?.delete("conversation_list", where: "group_id=? AND member_id=?", whereArgs: [group_id, member_id]);
}

//===========  Get Data ==============//

GetData(table) async {
  final db = await initDatabase;
//return db?.query(table, where:"Company_established_date <?" ,whereArgs: [date]);
  return db?.query("Conversation");
}

Get_conversation_list() async {
  final db = await initDatabase;
//return db?.query(table, where:"Company_established_date <?" ,whereArgs: [date]);
  return db?.query("conversation_list", orderBy: 'is_pin DESC,conversation_time DESC');
}

Get_group_message_status(id) async {
  final db = await initDatabase;
  return db?.query("group_message_status", where: "message_id", whereArgs: [id]);
}

Get_group_members(id) async {
  final db = await initDatabase;
  return db?.query("group_members", where: "group_id", whereArgs: [id]);
}
