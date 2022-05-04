const express = require("express");
const bodyParser = require("body-parser");
const {
    Logger
} = require("node-core-utils");
const defaultConfig = require("./config");
const {
    MongoDB
} = require("./lib/db");
const {
    logRequest
} = require("./lib/middleware");
const {
    API
} = require("./lib/api");
var cors = require('cors')
class App {
    constructor(config) {
        this.config = {
            ...defaultConfig,
            ...config
        };
        this.logger = new Logger("Intern Assessment");
        this.logger.info(`Starting...`);
        this.logRequest = logRequest;
        this.db = new MongoDB(this.config.db);
        this.startTimeString = "";

        this.init();
    }
    init() {
        this.logger.info("Initializing");
        this.logger.debug(this.config);
        this.environment = this.config.environment;

        this.server = express();
        this.server.set("trust_proxy", this.config.trustProxy);
        this.server.set("json spaces", this.config.jsonSpaces);
        this.server.use(cors());
        this.server.use(bodyParser.urlencoded(this.config.urlencoded));
        this.server.use(bodyParser.json({
            limit: this.config.uploadLimit
        }));
        this.server.set("app", this);
        this.server.use("/api", this.logRequest);
        this.server.use("/api", API);

        this.logger.info(`Initialized`);
    }

    start() {
        this.server.listen(this.config.port, '0.0.0.0', () => {
            this.logger.info(`listening on http://0.0.0.0:${this.config.port}`);
        });
        this.logger.info(`started in ${this.environment}.`);
        this.startTimeString = Date.now()
    }

    async exit() {
        this.logger.info(`exiting`);
        process.exit();
    }

    async getStatus() {
        let uptime = Date.now() - this.startTimeString
        return [await this.db.models.User.countDocuments(), {
                upTime: uptime
            },
            this.config
        ]
    }

    startTime() {
        return this.startTimeString
    }
}

if (require.main === module) {
    const app = new App();
    app.start();
} else {
    module.exports = App;
}