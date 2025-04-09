function Disposable() constructor {
    isDisposed = false;
    static dispose = function() {
        isDisposed = true;
    }
}

function DisposableManager() : Disposable() constructor {
    disposableItems = [];
 
    static registerDisposable = function(_disposable) {
        var _hasDisposeableKey = false;
        if(is_struct(_disposable)) {
            _hasDisposeableKey = variable_struct_exists(_disposable, "dispose");
        } else if( is_real(_disposable) && instance_exists(_disposable)) {
            _hasDisposeableKey = variable_instance_exists(_disposable, "dispose");
        }

        if(!_hasDisposeableKey) {
            throw "Struct or Instance did not have disposable member";
        }

        var _isMethod = is_callable(_disposable.dispose);

        if(!_isMethod) {
            throw "Struct or Instance has disposable member but its not a callable value";
        }
        
        array_push(disposableItems, _disposable);
    }
    
    
    static dispose = function() {
        isDisposed = true;

        var _length = array_length(disposableItems);
        for(var i = 0; i < _length; i += 1) {
            var _disposable = disposableItems[i];
            _disposable.dispose();
        }
        array_resize(disposableItems, 0);
    }
}