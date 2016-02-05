'use strict';

import React, { requireNativeComponent, Component } from 'react-native';
import resolveAssetSource from 'react-native/Libraries/Image/resolveAssetSource';

class MapView extends Component {
    /**
     * Any metadata that's associated with map markers.
     *
     * @type {object}
     * @private
     */
    _markerMeta;

    /**
     * An array of markers which are transformed ready for the bridge.
     *
     * @type {Array}
     * @private
     */
    _markersForBridge;

    /**
     * Creates a new map view react component.
     */
    constructor() {
        super();

        this._onChange = this._onChange.bind(this);
        this._markerMeta = {};
        this._markersForBridge = [];
    }

    /**
     * Handler for inbound events from the react native bridge.
     *
     * @param {Event} event
     * @private
     */
    _onChange(event: Event) {
        if (event.nativeEvent.target) {
            delete event.nativeEvent.target;
        }

        switch(event.nativeEvent.event) {
            case 'didTapMarker':
            case 'didBeginDraggingMarker':
            case 'didDragMarker':
            case 'didEndDraggingMarker':
                this._handleMarkerEvent(event);
                break;
            default:
                this.props[event.nativeEvent.event] && this.props[event.nativeEvent.event](event.nativeEvent);
                break;
        }
    }

    /**
     * Handles marker events by appending marker metadata to the returned event object.
     *
     * @param event
     * @private
     */
    _handleMarkerEvent(event: Event) {
        if (!this.props[event.nativeEvent.event]) {
            return;
        }

        event.nativeEvent.data.id = event.nativeEvent.data.publicId;

        delete event.nativeEvent.data.publicId;

        if (this._markerMeta[event.nativeEvent.data.id]) {
            event.nativeEvent.data.meta = this._markerMeta[event.nativeEvent.data.id];
        }

        this.props[event.nativeEvent.event](event.nativeEvent);
    }

    /**
     * Store any map marker metadata in JS land so it doesn't need to travel across the react bridge.
     *
     * @param nextProps
     */
    componentWillReceiveProps(nextProps: Object) {
        if (!nextProps.markers) {
            return;
        }

        this._markersForBridge = [];

        nextProps.markers.map((marker) => {
            let markerProps = {
                publicId: marker.id,
                latitude: marker.latitude,
                longitude: marker.longitude,  
                hexColor: marker.hexColor,  
            }
            if (marker.icon) {
                markerProps.icon = resolveAssetSource(marker.icon);
            }

            this._markersForBridge.push(markerProps);

            this._markerMeta[marker.id] = marker.meta || {};
        });
    }

    /**
     * The render method for this component.
     *
     * @return {XML}
     */
    render() {
        return (
            <PPTGoogleMap {...this.props} onChange={this._onChange} markers={this._markersForBridge} />
        );
    }
}

MapView.propTypes = {
    /**
     * The map view camera position.
     */
    cameraPosition: React.PropTypes.object,

    /**
     * If true the app will ask for the user's location and focus on it. Default value is false.
     */
    showsUserLocation: React.PropTypes.bool,

    /**
     * Controls whether scroll gestures are enabled (default) or disabled.
     */
    scrollGestures: React.PropTypes.bool,

    /**
     * Controls whether zoom gestures are enabled (default) or disabled.
     */
    zoomGestures: React.PropTypes.bool,

    /**
     * Controls whether tilt gestures are enabled (default) or disabled.
     */
    tiltGestures: React.PropTypes.bool,

    /**
     * Controls whether rotate gestures are enabled (default) or disabled.
     */
    rotateGestures: React.PropTypes.bool,

    /**
     * Controls whether gestures by users are completely consumed by the GMSMapView when gestures are enabled
     * (default YES).
     */
    consumesGesturesInView: React.PropTypes.bool,

    /**
     * Enables or disables the compass.
     */
    compassButton: React.PropTypes.bool,

    /**
     * Enables or disables the My Location button.
     */
    myLocationButton: React.PropTypes.bool,

    /**
     * Enables (default) or disables the indoor floor picker.
     */
    indoorPicker: React.PropTypes.bool,

    /**
     * Controls whether rotate and zoom gestures can be performed off-center and scrolled around (default YES).
     */
    allowScrollGesturesDuringRotateOrZoom: React.PropTypes.bool,

    /**
     * An array of markers which will be displayed on the map.
     */
    markers: React.PropTypes.arrayOf(React.PropTypes.shape({
        id: React.PropTypes.string,
        latitude: React.PropTypes.number.isRequired,
        longitude: React.PropTypes.number.isRequired,
        icon: React.PropTypes.any,
        hexColor: React.PropTypes.string,
        meta: React.PropTypes.object
    })),

    /**
     * Called repeatedly during any animations or gestures on the map (or once, if the camera is explicitly set).
     * This may not be called for all intermediate camera positions. It is always called for the final position of
     * an animation or gesture.
     */
    didChangeCameraPosition: React.PropTypes.func,

    /**
     * Called when the map becomes idle, after any outstanding gestures or animations have completed (or after the
     * camera has been explicitly set).
     */
    idleAtCameraPosition: React.PropTypes.func,

    /**
     * Called after a tap gesture at a particular coordinate, but only if a marker was not tapped.
     * This is called before deselecting any currently selected marker (the implicit action for tapping on the map).
     */
    didTapAtCoordinate: React.PropTypes.func,

    /**
     * Called after a long-press gesture at a particular coordinate.
     */
    didLongPressAtCoordinate: React.PropTypes.func,

    /**
     * Called after a marker has been tapped.
     */
    didTapMarker: React.PropTypes.func,

    /**
     * Called after an overlay has been tapped.
     */
    didTapOverlay: React.PropTypes.func,

    /**
     * Called when dragging has been initiated on a marker.
     */
    didBeginDraggingMarker: React.PropTypes.func,

    /**
     * Called after dragging of a marker ended.
     */
    didEndDraggingMarker: React.PropTypes.func,

    /**
     * Called while a marker is dragged.
     */
    didDragMarker: React.PropTypes.func,

    /**
     * Called when the My Location button is tapped.
     */
    didTapMyLocationButtonForMapView: React.PropTypes.func,

    /**
     * Property types required by react native.
     */
    renderToHardwareTextureAndroid: React.PropTypes.bool,
    accessibilityLiveRegion: React.PropTypes.string,
    accessibilityComponentType: React.PropTypes.string,
    importantForAccessibility: React.PropTypes.string,
    accessibilityLabel: React.PropTypes.string,
    onLayout: React.PropTypes.bool,
    testID: React.PropTypes.string
};

var PPTGoogleMap = requireNativeComponent('PPTGoogleMap', MapView, {
    nativeOnly: {
        onChange: true
    }
});

module.exports = MapView;
