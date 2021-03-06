import Foundation
import PackageManagerKit
import LRActionKit
import PromiseKit

public class Workspace: PluginContext {

    public let log = EnvLog(origin: "")

    public let packageManager: LRPackageManager

    public let plugins: PluginManager

    public let rubies: RubyRuntimeRepository

    public let projects: ProjectList

    private var disposed = false


    public init() {
        packageManager = LRPackageManager()
        packageManager.addPackageType(GemPackageType())
        packageManager.addPackageType(NpmPackageType())

        let pc = PluginContextImpl(packageManager: packageManager)
        plugins = PluginManager(context: pc)

        rubies = RubyRuntimeRepository()

        projects = ProjectList()

        let lb = log.beginUpdating()
        lb.addChild(plugins.log)
        lb.commit()

        _processing.add(plugins.updating)
    }

    public func dispose() {
        disposed = true
        plugins.dispose()
    }

    public var processing: Processable {
        return _processing
    }

    private let _processing = ProcessingGroup()

}

private struct PluginContextImpl: PluginContext {

    let packageManager: LRPackageManager

}
