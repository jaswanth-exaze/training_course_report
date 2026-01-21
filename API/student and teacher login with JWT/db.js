const mysql = require("mysql2");

const db = mysql.createConnection({
  host: "localhost",
  user: "root",
  password: "root",
  database: "school_auth",
});

db.connect((err)=>{
    if (err){
        console.log('Database Connection Failed::',err)
    }
    else{
        console.log('Database connected Successfully')
    }
});

module.exports = db;