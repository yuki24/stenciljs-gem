import { Component } from '@stencil/core';

@Component({
  tag: '<%= file_name %>',
  styleUrl: '<%= file_name %>.scss',
  shadow: true
})
export class <%= class_name %> {
  render() {
    return <div>Hello, World!</div>;
  }
}
