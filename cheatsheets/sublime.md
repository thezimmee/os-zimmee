# Sublime Text

## Creating a color scheme

- Organize scopes from globals and built-ins to user specific scopes.
- Group styles together to match a desired outcome. For example, group all operator styles into a single rule definition.

## Scopes

[Scope documentation](https://www.sublimetext.com/docs/3/scope_naming.html)

### Punctuation

`punctuation.definition`, `punctuation.section`, `punctuation.section.block`, `punctuation.separator`, `punctuation.terminator`

### Comments

`comment`

### Storage

`storage.type`, `storage.type.function.arrow`, `storage.modifier`

### Strings

`string`, `string.regexp`
        
### Constants

`constant.numeric`, `constant.language`, `constant.character`, `constant.other`

### Keywords

`keyword.control`, `keyword.control.import`, `keyword.control.flow`, `keyword.control.at-rule`, `keyword.operator`, `keyword.operator.word`, `keyword.operator.assignment`, `keyword.operator.arithmetic`, `keyword.operator.bitwise`, `keyword.operator.comparison`, `keyword.operator.logical`, `keyword.operator.relational`, `keyword.operator.ternary`, `keyword.declaration`, `keyword.other.unit`, `keyword.other.important`

### Support

`support.function`, `support.macro`, `support.constant`, `support.type`, `support.class`

### Variables

`variable.other`, `variable.other.constant`, `variable.other.readwrite`, `variable.language`, `variable.parameter`, `variable.function`, `variable.annotation`

### Markup

`markup.heading`, `markup.list`, `markup.list.numbered.bullet`, `markup.list.unnumbered.bullet`, `markup.quote`, `markup.bold`, `markup.italic`, `markup.raw`, `markup.inserted`, `markup.deleted`

### Invalid

`invalid.illegal`, `invalid.deprecated`

### Diffs

`diff.deleted`, `diff.inserted`

### Entity

NOTE: Color schemes should specify a color for `entity.name` that will be applied to classes, types, structs, interfaces and many other data structures. This color can be overridden for the two scopes `entity.name.tag` and `entity.name.section`, which are used for different types of constructs.

`entity.name`, `entity.name.class`, `entity.name.inherited`-class, `entity.name.function`, `entity.name.function`.constructor, `entity.name.struct`, `entity.name.enum`, `entity.name.union`, `entity.name.trait`, `entity.name.interface`, `entity.name.impl`, `entity.name.type`, `entity.name.namespace`, `entity.name.constant`, `entity.name.label`, `entity.name.section`, `entity.name.tag`, `entity.other`, `entity.other.attribute-name`, `entity.other.pseudo-element`, `entity.other.pseudo-class`