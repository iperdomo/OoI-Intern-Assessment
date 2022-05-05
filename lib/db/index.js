const mongoose = require("mongoose");
const { Logger } = require("node-core-utils");
const models = require("./models");
require("dotenv").config();

class MongoDB {
    constructor(config) {
        this.config = config || {
            url: process.env.DB_URL || "mongodb://localhost",
            database: process.env.DB_NAME || "juniper",
            mongooseCfg: {
                useNewUrlParser: true,
                useCreateIndex: true,
                useUnifiedTopology: true,
                useFindAndModify: false,
            },
        };
        this.models = models;
        this.logger = new Logger("MongoDB");
        this.connectionString = `${this.config.url}/${this.config.database}?authSource=admin`;

        this.logger.info(`Starting...`);
        this.init();
    }

    async init() {
        this.logger.info("Initializing:");
        this.logger.debug(this.config);
        try {
            this.mongoose = await mongoose.connect(
                this.connectionString,
                this.config.mongooseCfg
            );
        } catch (e) {
            return this.logger.error(e);
        }

        this.logger.info(`Connecting: ${this.connectionString}`);
        this.logger.info("Initialized");
    }

    async disconnect() {
        await this.mongoose.connection.close();
    }
}

module.exports = { MongoDB };