import React from 'react'
import ReactDOM from 'react-dom'

export default class PreventOutsideScroll extends React.PureComponent {
  constructor (props) {
    super(props)
    const childProps = React.Children.only(this.props.children).props
    // use the original ref name if exist
    this.childRefName =
      childProps && childProps.ref ?
      childProps.ref :
      'child'
    this.onScroll = this.onScroll.bind(this)
  }
  componentDidMount () {
    const scroller = this.getScroller()
    scroller.addEventListener('wheel', this.onScroll)
  }
  componentWillUnmount () {
    const scroller = this.getScroller()
    scroller.removeEventListener('wheel', this.onScroll)
  }
  render () {
    // add ref to find child's DOM node.
    // https://facebook.github.io/react/blog/2015/03/03/react-v0.13-rc2.html#react.cloneelement
    return React.cloneElement(this.props.children, {
      ref: this.childRefName,
    })
  }
  getScroller () {
    return ReactDOM.findDOMNode(this.refs[this.childRefName])
  }
  onScroll (event) {
    const {currentTarget, deltaY} = event
    const {scrollTop, scrollHeight} = currentTarget
    if (
      (deltaY < 0 && scrollTop <= 0) ||
      (
        deltaY > 0 &&
        scrollTop >= scrollHeight - parseInt(getComputedStyle(currentTarget).height)
      )
    ) {
      event.preventDefault()
    }
  }
}
