    // load data from yaml
    import org.yaml.snakeyaml.Yaml
    .
    .
    .
    def service_properties = readFile "path to file.yaml"
    def parsed_service_properties = loadYAML(service_properties)
    def data = parsed_service_propertiesInMap['$some_properties']
    .
    .
    .
    @NonCPS
    def loadYAML(String data) {
    def yaml = new Yaml()
    return yaml.load(data)
    }
