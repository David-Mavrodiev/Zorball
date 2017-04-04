/*globals module*/
let connString;

if (process.env.NODE_ENV === 'production') {
    connString = "mongodb://Admin:admin@ds163667.mlab.com:63667/egorski";
} else {
    connString = "mongodb://localhost/egorski";
}

module.exports = {
    connectionString: connString,
    cookieText: "Secret"
};