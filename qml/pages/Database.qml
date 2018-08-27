import QtQuick 2.2
import QtQuick.LocalStorage 2.0 as Sql

Item {
    // reference to the database object
    property var _db;

    property variant record

    function initDatabase() {
        // initialize the database object
        console.log('initDatabase()')
        _db = Sql.LocalStorage.openDatabaseSync("OldiesRadio", "1.0", "OldiesRadio settings SQL database", 1000000);
        _db.transaction( function(tx) {
            // Create the database if it doesn't already exist
            console.log("Create the database if it doesn't already exist")
            tx.executeSql('CREATE TABLE IF NOT EXISTS settings(keyname TEXT UNIQUE, value TEXT, textName TEXT)')
        })
    }

    function storeData(keyname, value, textName) {
        // stores data to _db
        console.log('storeData()', keyname, value, textName)
        if(!_db) { return; }
        _db.transaction( function(tx) {
            var result = tx.executeSql('INSERT OR REPLACE INTO settings VALUES (?,?,?);', [keyname,value,textName]);
            if(result.rowsAffected === 1) {// use update
                console.log('record exists, update it')
            }
        })
    }

    function getValue(keyname) {
        console.log('getValue()', keyname)
        var res
        if(!_db) { return; }
        _db.transaction( function(tx) {
            var result = tx.executeSql('SELECT value from settings WHERE keyname=?', [keyname]);
            if(result.rows.length === 1) {// use update
                res = result.rows.item(0).value
            }
        })
        return res
    }

    function getName(keyname) {
        console.log('getName()', keyname)
        var res
        if(!_db) { return; }
        _db.transaction( function(tx) {
            var result = tx.executeSql('SELECT textName from settings WHERE keyname=?', [keyname]);
            if(result.rows.length === 1) {// use update
                res = result.rows.item(0).textName
                console.log("tx result", res)
            }
        })
        return res
    }

}
