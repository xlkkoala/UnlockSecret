//
//  NSString+Joker.h
//  Additions_PS
//
//  Created by pengshuai on 15/1/4.
//  Copyright (c) 2015年 pengshuai. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  目录类型
 */
typedef NS_ENUM(NSInteger, DirectoryType){
    /**
     *  MainBundle
     */
    DirectoryTypeMainBundle = 0,
    /**
     *  Library
     */
    DirectoryTypeLibrary,
    /**
     *  Documents
     */
    DirectoryTypeDocuments,
    /**
     *  Cache
     */
    DirectoryTypeCache
};

/**
 *  NSFileManager 扩展方法
 */
@interface NSFileManager (Joker)

/**
 *  读取文件
 *
 *  @param file 文件名
 *  @param type type
 *
 *  @return 文件内容 NSString
 */
+ (NSString *)readTextFile:(NSString *)file
                    ofType:(NSString *)type;


/**
 *  将NSArray 保存到plist文件中
 *
 *  @param path     path
 *  @param fileName 文件名称
 *  @param array    Array
 *
 *  @return YES:成功;NO:失败
 */
+ (BOOL)saveArrayToPath:(DirectoryType)path
           withFilename:(NSString *)fileName
                  array:(NSArray *)array;


/**
 *  读取plist文件
 *
 *  @param path     路径
 *  @param fileName plist文件名
 *
 *  @return NSArray
 */
+ (NSArray *)loadArrayFromPath:(DirectoryType)path
                    withFilename:(NSString *)fileName;

/**
 *  获取Bundle 文件路径
 *
 *  @param fileName fileName 文件名称
 *
 *  @return 文件路径
 */
+ (NSString *)getBundlePathForFile:(NSString *)fileName;

/**
 *  获取Documents directory 下文件路径
 *
 *  @param fileName 文件名称
 *
 *  @return 文件路径
 */
+ (NSString *)getDocumentsDirectoryForFile:(NSString *)fileName;


/**
 *  获取 Library directory下文件路径
 *
 *  @param fileName 文件名称
 *
 *  @return 文件路径
 */
+ (NSString *)getLibraryDirectoryForFile:(NSString *)fileName;


/**
 *  获取 Cache directory下文件路径
 *
 *  @param fileName 文件名称
 *
 *  @return 文件路径
 */
+ (NSString *)getCacheDirectoryForFile:(NSString *)fileName;

/**
 *  删除文件
 *
 *  @param fileName   删除文件名称
 *  @param directory  文件目录路径
 *
 *  @return YES:成功;NO:失败
 */
+ (BOOL)deleteFile:(NSString *)fileName fromDirectory:(DirectoryType)directory;

/**
 *  移动文件
 *
 *  @param fileName    文件名称
 *  @param origin      源文件的目录
 *  @param destination 文件的目标目录
 *
 *  @return YES:成功;NO:失败
 */
+ (BOOL)moveLocalFile:(NSString *)fileName
        fromDirectory:(DirectoryType)origin
          toDirectory:(DirectoryType)destination;

/**
 *  将文件移动到文件夹中
 *
 *  @param fileName    文件名称
 *  @param origin      源文件的目录
 *  @param destination 文件的目标目录
 *  @param folderName  文件夹名称的文件。如果文件夹不存在,它将被自动创建
 *
 *  @return YES:成功;NO:失败
 */
+ (BOOL)moveLocalFile:(NSString *)fileName
        fromDirectory:(DirectoryType)origin
          toDirectory:(DirectoryType)destination
       withFolderName:(NSString *)folderName;

/**
 *  复制一个文件到另一个目录
 *
 *  @param origin      源文件的目录
 *  @param destination 文件的目标目录
 *
 *  @return YES:成功;NO:失败
 */
+ (BOOL)duplicateFileAtPath:(NSString *)origin
                  toNewPath:(NSString *)destination;


/**
 *  重命名文件
 *
 *  @param origin  源文件的目录
 *  @param path    子目录路径
 *  @param oldName 旧文件名
 *  @param newName 新文件名
 *
 *  @return YES:成功;NO:失败
 */
+ (BOOL)renameFileFromDirectory:(DirectoryType)origin
                         atPath:(NSString *)path
                    withOldName:(NSString *)oldName
                     andNewName:(NSString *)newName;

/**
 *  Get the App settings for a given key
 *
 *  @param objKey Key to get the object
 *
 *  @return Return the object for the given key
 */
+ (id)getAppSettingsForObjectWithKey:(NSString *)objKey;

/**
 *  Set the App settings for a given object and key. The file will be saved in the Library directory
 *
 *  @param value  Object to set
 *  @param objKey Key to set the object
 *
 *  @return Return YES if the operation was successful, otherwise NO
 */
+ (BOOL)setAppSettingsForObject:(id)value
                         forKey:(NSString *)objKey;

/**
 *  Get the given settings for a given key
 *
 *  @param settings Settings filename
 *  @param objKey   Key to set the object
 *
 *  @return Return the object for the given key
 */
+ (id)getSettings:(NSString *)settings
     objectForKey:(NSString *)objKey;

/**
 *  Set the given settings for a given object and key. The file will be saved in the Library directory
 *
 *  @param settings Settings filename
 *  @param value    Object to set
 *  @param objKey   Key to set the object
 *
 *  @return Return YES if the operation was successful, otherwise NO
 */
+ (BOOL)setSettings:(NSString *)settings
             object:(id)value forKey:(NSString *)objKey;

@end
