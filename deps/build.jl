using BinDeps
@BinDeps.setup

deps = [ libxgboostwrapper = library_dependency("xgboostwrapper", aliases = ["libxgboostwrapper.so"]) ]

prefix=joinpath(BinDeps.depsdir(libxgboostwrapper),"usr")
provides(BuildProcess,
           (@build_steps begin
               `rm -rf xgboost`
               `git clone https://github.com/tqchen/xgboost.git`
               CreateDirectory(prefix)
               CreateDirectory(joinpath(prefix, "lib"))
               @build_steps begin
                   ChangeDirectory("xgboost")
                   FileRule(joinpath(prefix,"lib","libxgboostwrapper.so"), @build_steps begin
                       `git checkout eee304662452feda389e44546a72d1c7d994b123` # v0.40
                       `bash build.sh`
                       `cp wrapper/libxgboostwrapper.so $prefix/lib`
                   end)
               end
            end),
         libxgboostwrapper)

@BinDeps.install Dict(:xgboostwrapper => :_xgboost)
