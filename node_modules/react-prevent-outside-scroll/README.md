# React Prevent Outside Scroll

A react component that prevents outside scroll when inside scroll to the edge.

## Install

```bash
npm install --save react-prevent-outside-scroll
```

react-prevent-outside-scroll require react & react-dom as [peer-dependencies](https://docs.npmjs.com/files/package.json#peerdependencies), so make sure you have installed react & react-dom.

```bash
npm install react react-dom
```

## Examples

```js
import React from 'react'
import PreventOutsideScroll from 'react-prevent-outside-scroll'

class ExampleComponent extends React.PureComponent {
  render () {
    <PreventOutsideScroll>
      <div id='scroller'
        style={{
          overflow: 'auto',
          height: 100,
          width: 100
          position: 'fixed',
          top: 100,
          left: 100,
        }}
      >
        <div style={{height: 10000}}>
          Sufficiently high content...
          When #scroller inside scroll to the edge, outside does not scroll.
        </div>
      </div>
    </PreventOutsideScroll>
  }
}
```

## Development

```bash
npm i
npm run dev
```
