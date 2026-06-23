function options = apply_defaults(options, defaults)
%APPLY_DEFAULTS Merge user options into a known default-option structure.
if isempty(options), options = struct(); end
if ~isstruct(options) || ~isscalar(options)
    error('auc:InvalidOptions', 'Options must be a scalar struct.');
end
names = fieldnames(options);
for index = 1:numel(names)
    if ~isfield(defaults, names{index})
        error('auc:UnknownOption', 'Unknown option: %s', names{index});
    end
    defaults.(names{index}) = options.(names{index});
end
options = defaults;
end
