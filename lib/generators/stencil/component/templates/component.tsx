import { Component } from '@stencil/core';

@Component({
  tag: '<%= file_name %>',
  styleUrl: '<%= file_name %>.scss'
})
export class <%= class_name %> {
  render() {
    return <div>Hello, World!</div>;
  }
}
