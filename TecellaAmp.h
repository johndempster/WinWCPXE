/*******************************************
* TecellaAmp.h
* Copyright 2007-2009 Tecella LLC
*
*/


#ifndef __TECELLA_AMP__
#define __TECELLA_AMP__

#ifndef DLLEXPORT
#define DLLEXPORT
#endif


/*******************************************
* Some useful typedefs/defines
*/
typedef int TECELLA_HNDL;           /**< A device handle to let the API know which device you're addressing. */
#define TECELLA_ALLCHAN 0x8000      /**< Use this in place of a channel number to indicate all channels. */


/*****************************************//**
* TECELLA_HW_MODEL
* Specifies the type of device we're connected to or want to connect to.
* Use in conjunction with tecella_initialize() and tecella_get_hw_props().
*/
typedef enum TECELLA_HW_MODEL {
	TECELLA_HW_MODEL_AUTO_DETECT,
	TECELLA_HW_MODEL_TRITON,
	TECELLA_HW_MODEL_TRITON_PLUS,
	TECELLA_HW_MODEL_JET,
	TECELLA_HW_MODEL_RICHMOND,
	TECELLA_HW_MODEL_PROTEUS,
	TECELLA_HW_MODEL_APOLLO,
	TECELLA_HW_MODEL_WALL_E,
	TECELLA_HW_MODEL_SHASTA,
	TECELLA_HW_MODEL_AMADEUS,
	TECELLA_HW_MODEL_PICO
} TECELLA_HW_MODEL;


/*******************************************
* Generic values for source selection.
* Use with tecella_chan_set_source().
* Depricated: use tecella_get_source_label() instead.
*/

#define TECELLA_SOURCE_NONE    0         /**< Tells tecella_chan_set_source() to use no input */
#define TECELLA_SOURCE_HEAD    1         /**< Tells tecella_chan_set_source() to use the regular head inputs. (Default) */
#define TECELLA_SOURCE_MODEL1  2         /**< Tells tecella_chan_set_source() to use the internal model cell.  May or may not be supported, see tecella_get_hw_props().*/
#define TECELLA_SOURCE_MODEL2  3         /**< Tells tecella_chan_set_source() to use no input.  May or may not be supported, see tecella_get_hw_props(). */


/*******************************************
* Generic values for gain selection.
* Use with tecella_chan_set_gain().
* Depricated: use tecella_get_gain_label() instead.
*/
#define TECELLA_GAIN_A       0
#define TECELLA_GAIN_B       1
#define TECELLA_GAIN_C       2
#define TECELLA_GAIN_D       3


/*****************************************//**
* TECELLA_REGISTER
* An enumeration of all per-channel settings that may exist on a device.
* To see if a setting is supported by the device, use tecella_get_reg_props().
*/
typedef enum TECELLA_REGISTER {
	TECELLA_REG_CFAST     = 0x00,
	TECELLA_REG_CSLOW_A   = 0x01,
	TECELLA_REG_CSLOW_B   = 0x02,
	TECELLA_REG_CSLOW_C   = 0x03,
	TECELLA_REG_CSLOW_D   = 0x04,
	TECELLA_REG_RSERIES   = 0x05,
	TECELLA_REG_LEAK      = 0x06,
	TECELLA_REG_JP        = 0x07,
	TECELLA_REG_JP_FINE   = 0x08,
	TECELLA_REG_LEAK_FINE = 0x09,
	TECELLA_REG_ICMD_OFFSET = 0x0A,
	TECELLA_REG_BOOST_FREQUENCY = 0x0B,
	TECELLA_REG_BOOST_GAIN = 0x0C,
} TECELLA_REGISTER;

/*****************************************//**
* TECELLA_OFFSET_ADJUST_MODE
* Used by tecella_auto_comp_offset_adjust_mode_set() to indicate
* if remaining offsets in the response after tecella_auto_comp()
* should be compensated using JP and/or offset in the response.
*/
enum TECELLA_OFFSET_ADJUST_MODE {
	TECELLA_OAM_OFF = 0,
	TECELLA_OAM_ADJUST_STIMULUS = 1,  /**< Adjusts JP.  JP must be supported by the hardware. */
	TECELLA_OAM_ADJUST_RESPONSE = 2,  /**< Adjusts the response offset. */
	TECELLA_OAM_ADJUST_STIMULUS_AND_RESPONSE = 3, /**< Adjusts both JP and the response offset. */
};

/*****************************************//**
* TECELLA_ERRNUM
* All functions in this API return one of these error values.
*/
typedef enum TECELLA_ERRNUM {
	//No error
	TECELLA_ERR_OK = 0x000,

	//General errors
	TECELLA_ERR_NOT_IMPLEMENTED = 0x001,
	TECELLA_ERR_NOT_SUPPORTED = 0x002,
	TECELLA_ERR_BAD_HANDLE = 0x003,
	TECELLA_ERR_INVALID_CHANNEL = 0x004,
	TECELLA_ERR_INVALID_STIMULUS = 0x005,
	TECELLA_ERR_INVALID_CHOICE = 0x006,
	TECELLA_ERR_ALLCHAN_NOT_ALLOWED = 0x007,
	TECELLA_ERR_RETURN_POINTER_NULL = 0x008,
	TECELLA_ERR_ARGUMENT_POINTER_NULL = 0x009,
	TECELLA_ERR_VALUE_OUTSIDE_OF_RANGE = 0x00A,
	TECELLA_ERR_INVALID_REGISTER_COMBINATION = 0x00B,    /**< One of the following constraints was not met: 1) Leak must be greater than Rseries. */
	TECELLA_ERR_DEVICE_CONTENTION = 0x00C,               /**< Certain tasks cannot be run in parallel, such as diagnostics and acquisition. */
	TECELLA_ERR_INTERNAL = 0x00D,
	TECELLA_ERR_FILE_DOES_NOT_EXIST = 0x00E,
	TECELLA_ERR_BAD_FILE_FORMAT = 0X00F,
	TECELLA_ERR_STD_EXCEPTION = 0x0010,
	TECELLA_ERR_UNKNOWN_EXCEPTION = 0x0011,

	//Initialization errors
	TECELLA_ERR_OKLIB_NOT_FOUND = 0x100,
	TECELLA_ERR_DEVICE_OPEN_FAILED = 0x101,
	TECELLA_ERR_DEVICE_INIT_FAILED = 0x102,
	TECELLA_ERR_INVALID_DEVICE_INDEX = 0x103,
	TECELLA_ERR_BAD_FIRMWARE_VERSION = 0x104,

	//Stimulus errors
	TECELLA_ERR_STIMULUS_INVALID_SEGMENT_COUNT = 0x200,
	TECELLA_ERR_STIMULUS_INVALID_DURATION = 0x201,
	TECELLA_ERR_STIMULUS_INVALID_VALUE = 0x202,
	TECELLA_ERR_STIMULUS_INVALID_DURATION_DELTA = 0x203,
	TECELLA_ERR_STIMULUS_INVALID_VALUE_DELTA = 0x204,
	TECELLA_ERR_STIMULUS_INVALID_RAMP_STEP_COUNT = 0x205,
	TECELLA_ERR_STIMULUS_INVALID_RAMP_END_VALUE = 0x206,
	TECELLA_ERR_STIMULUS_INVALID_DELTA_COUNT = 0x207,
	TECELLA_ERR_STIMULUS_INVALID_REPEAT_COUNT = 0x208,
	TECELLA_ERR_STIMULUS_INVALID_SEGMENT_SEQUENCE = 0x209,

	//Acquisition errors
	TECELLA_ERR_INVALID_SAMPLE_PERIOD = 0x300,
	TECELLA_ERR_HW_BUFFER_OVERFLOW = 0x301,
	TECELLA_ERR_SW_BUFFER_OVERFLOW = 0x302,
	TECELLA_ERR_ACQ_CRC_FAILED = 0x303,
	TECELLA_ERR_CHANNEL_BUFFER_OVERFLOW = 0x304,

} TECELLA_ERRNUM;


/*****************************************//**
* tecella_lib_props
* Represents the version of the DLL being used.
* For use with tecella_get_lib_props().
*/
typedef struct tecella_lib_props {
	int     v_maj;             /**< Version major. */
	int     v_min;             /**< Version minor. */
	int     v_dot;             /**< Version sub minor. */
	wchar_t description[256];  /**< May contain extra info like the release name and date. */
} TECELLA_LIB_PROPS;


/*****************************************//**
* tecella_hw_props
* Properties of the connected device.
* For use with tecella_get_hw_props().
*/
#define TECELLA_HW_PROPS_DEVICE_NAME_SIZE 32
#define TECELLA_HW_PROPS_SERIAL_NUMBER_SIZE 32
#define TECELLA_HW_PROPS_USER_CONFIG_NAME_SIZE 32

typedef struct tecella_hw_props {
	TECELLA_HW_MODEL hw_model;
	wchar_t     device_name[TECELLA_HW_PROPS_DEVICE_NAME_SIZE]; /**< Name of the device. */
	wchar_t     serial_number[TECELLA_HW_PROPS_SERIAL_NUMBER_SIZE]; /**< The serial number, which is unique to each unit. */
	int         hwvers;                         /**< Contains the firmware version being used. */
	int         nchans;                         /**< Number of channels.  Note: Channel numbering goes from [0, nchans-1]. */
	int         nslots;                         /**< Number of slots populated with a channel board.  (Does not include the controller board). */
	int         nsources;                       /**< Number of sources selectable (see TECELLA_REG_SOURCE) */
	int         ngains;                         /**< Number of gains selectable (see TECELLA_REG_GAIN) */
	int         ncslows;                        /**< Number of cslows slectable */
	int         n_utility_dacs;                 /**< Number of utility DACs available. (limits the max index passed to tecella_utility_dac functions.) */
	int         nstimuli;                       /**< Number of simultaneous stimuli supported (see TECELLA_REG_VCMD_SELECT) */
	int         max_stimulus_segments;          /**< Maximum number of segments supported per stimulus. */
	bool        supports_async_stimulus;        /**< If true, tecella_acquire_start_stimulus() can be used. */
	bool        supports_oscope;                /**< Indicates if the amplifier can be used as an oscilloscope. */
	bool        supports_vcmd;                  /**< Indicates if the amplifier can produce a voltage stimulus. (See TECELLA_STIMULUS_MODE_VCMD) */
	double      stimulus_value_min;             /**< Minimum value supported by a stimulus. */
	double      stimulus_value_max;             /**< Maximum value supported by a stimulus. */
	double      stimulus_value_lsb;             /**< The stimulus can only take on values in intervals of stimulus_value_lsb from stimulus_value_min to stimulus_value_max. */
	double      stimulus_ramp_step_size;        /**< Each step of a ramp stimulus segment will have it's value increased by this amount when using the non EX functions. */
	bool        supports_icmd;                  /**< Indicates if the amplifier can produce a current stimulus. (See TECELLA_STIMULUS_MODE_ICMD) */
	double      reserved_00;                    /**< Minimum amp value supported by a icmd stimulus. */
	double      reserved_01;                    /**< Maximum amp value supported by a icmd stimulus. */
	double      reserved_02;                    /**< The icmd stimulus can only take on current values in intervals of stimulus_value_lsb from stimulus_value_min to stimulus_value_max. */
	double      reserved_03;                    /**< Each step of a ramp icmd segment will have it's value increased by this amount. */
	double      stimulus_segment_duration_max;  /**< The maximum duration a segment can have. */
	double      stimulus_segment_duration_lsb;  /**< Duration can only take on values in intervals of stimulus_segment_duration_lsb. */
	int         stimulus_delta_count_max;       /**< The maximum number of delta iterations a stimulus may have. */
	int         stimulus_repeat_count_max;      /**< The maximum number of repeat iterations a stimulus may have. */
	int         stimulus_ramp_steps_max;        /**< The maximum number of ramp steps supported by a single stimulus segment. */
	bool        supports_zap;                   /**< Indicates if the amplifier supports tecella_stimulus_zap(). */
	double      zap_value_min;                  /**< Minimum zap value supported by tecella_stimulus_zap(). */
	double      zap_value_max;                  /**< Maximum zap value supported by tecella_stimulus_zap(). */
	double      zap_value_lsb;                  /**< The zap stimulus can only take on voltage values in intervals of zap_value_lsb from zap_value_min to zap_value_max. */
	bool        supports_bessel;                /**< Indicates if a bessel filter is supported */
	int         bessel_value_min;               /**< Minimum programmable bessel value. */
	int         bessel_value_max;               /**< Maximum programmable bessel value. */
	double      utility_dac_min;                /**< Utility DAC min in Volts. */
	double      utility_dac_max;                /**< Utility DAC max in Volts. */
	double      utility_dac_lsb;                /**< Utility DAC lsb in Volts. */
	double      sample_period_min;              /**< Minimum sample period supported in seconds. */
	double      sample_period_max;              /**< Maximum sample period supported in seconds. */
	double      sample_period_lsb;              /**< Deprecated. The sample period can only take on values in intervals of sample_period_lsb from sample_period_min to sample_period_max */
	int         bits_per_sample;                /**< The number of bits per sample. */
	int         user_config_count;              /**< Contains the number of configurations selectable with tecella_configuration_set() */
	wchar_t     user_config_name[TECELLA_HW_PROPS_USER_CONFIG_NAME_SIZE]; /**< The name of the configuration as currently specified / selected. */
} TECELLA_HW_PROPS;

/*****************************************//**
* tecella_hw_props_ex_01 subject to change
* Properties of the connected device.
* For use with tecella_get_hw_props_ex_01().
*/
#define TECELLA_HW_PROPS_ACQUISITION_UNITS_SIZE 32
#define TECELLA_HW_PROPS_STIMULUS_UNITS_SIZE 32
#define TECELLA_HW_PROPS_GAIN_NAME_SIZE 32

typedef struct tecella_hw_props_ex_01{
	wchar_t acquisition_units[TECELLA_HW_PROPS_ACQUISITION_UNITS_SIZE];
	wchar_t stimulus_units[TECELLA_HW_PROPS_STIMULUS_UNITS_SIZE];
	int slew_count;
	double stimulus_ramp_step_size_min;       /**< The value_delta field can take can be down to this value in stimulus_value_lsb increments. */
	double stimulus_ramp_step_size_max;       /**< The value_delta field can take can be up to this value in stimulus_value_lsb increments. */
	bool supports_hpf;
	int hpf_value_min;
	int hpf_value_max;
	bool supports_chan_set_stimulus;			/**< Some systems with multiple stimuli can map any channel to any stimulus via tecella_chan_set_stimulus(). */
	bool supports_stimulus_steering;			/**< used on Amadeus. */
	int stimulus_steering_index_min;
	int stimulus_steering_index_max;
	bool stimulus_steering_can_be_disabled;
	int dynamic_system_monitor_count;     /**< Indicates how many points the dynamic system monitor can probe. See tecella_system_monitor_dynamic_set().*/
	double trigger_in_delay_min;
	double trigger_in_delay_max;
	double trigger_in_delay_lsb;
	bool supports_iclamp_enable;          /**< Indicates if the iclamp can be enabled and dissabled via tecella_chan_set_iclamp_enable(). */
	bool supports_vcmd_enable;            /**< Indicates if the vcmd can be enabled and dissabled via tecella_chan_set_vcmd_enable(). */
	bool supports_telegraphs;
	int ngains1;
	wchar_t gain1_name[TECELLA_HW_PROPS_GAIN_NAME_SIZE];
	int ngains2;
	wchar_t gain2_name[TECELLA_HW_PROPS_GAIN_NAME_SIZE];
} TECELLA_HW_PROPS_EX_01;

/*****************************************//**
* tecella_reg_props
* Provides useful information about a register for a specific device.
* For use with tecella_get_reg_props().
*/
#define TECELLA_REG_PROPS_LABEL_SIZE 32
#define TECELLA_REG_PROPS_UNITS_SIZE 32

typedef struct tecella_reg_props {
	wchar_t      label[TECELLA_REG_PROPS_LABEL_SIZE];        /**< Label that should be used for this register in a GUI. */
	wchar_t      units[TECELLA_REG_PROPS_UNITS_SIZE];        /**< Units used when represented as a double. */
	bool         supported;        /**< Indicates if the register is supported by the device. */
	bool         can_be_disabled;  /**< Indicates if you can disable this register. */
	double       v_min;            /**< Minimum value for when calling tecella_chan_set(). */
	double       v_max;            /**< Maximum value for when calling tecella_chan_set(). */
	double       v_lsb;            /**< Indicates the precision of the double value. */
	unsigned int v_divisions;      /**< The number of valid values in the range [v_min,v_max] */
	double       v_default;        /**< Default value upon initialization. */
	double       pct_lsb;          /**< Indicates the precision of the double value when represented in percent. */
} TECELLA_REG_PROPS;


/*****************************************//**
* tecella_system_monitor_result
* Contains information about results returned by tecella_system_monitor_get_result().
*/
#define TECELLA_SYSTEM_MONITOR_RESULT_LABEL_SIZE 32
#define TECELLA_SYSTEM_MONITOR_UNITS_LABEL_SIZE 32

typedef struct tecella_system_monitor_result {
	wchar_t label[TECELLA_SYSTEM_MONITOR_RESULT_LABEL_SIZE];  /**< Label that should be used for this result in a GUI. */
	wchar_t units[TECELLA_SYSTEM_MONITOR_UNITS_LABEL_SIZE];   /**< Units used for value and value_expected. */
	int     board_index;              /**< Indicates which board of the system this result is for. */
	int     board_result_index;       /**< Indicates the result index for the specified board. Not all that usefull, but you never know.*/
	double  value;                    /**< The measured value. */
	double  value_expected;           /**< The expected value. */
	double  value_expected_min;       /**< The minimum expected value. Any value less than this should be flagged.*/
	double  value_expected_max;       /**< The minimum expected value. Any value greater than this should be flagged.*/
} TECELLA_SYSTEM_MONITOR_RESULT;

\
/*****************************************//**
* TECELLA_STIMULUS_SEGMENT_TYPE
* Specifies the segment type in tecella_stimulus_segment.
*/
typedef enum TECELLA_STIMULUS_SEGMENT_TYPE {
	TECELLA_STIMULUS_SEGMENT_SET,       /**< A flat segment. */
	TECELLA_STIMULUS_SEGMENT_DELTA,     /**< A flat segment that changes its amplitude and/or duration after each iteration. */
	TECELLA_STIMULUS_SEGMENT_RAMP,      /**< A segment that interpolates from one amplitude to another over a fixed duration. */
} TECELLA_STIMULUS_SEGMENT_TYPE;


/*****************************************//**
* tecella_stimulus_segment
* Create an array of these and pass it to tecella_vcmd_set().
*/
typedef struct tecella_stimulus_segment {
	TECELLA_STIMULUS_SEGMENT_TYPE type; /**< Type of segment. */
	double value;                       /**< Amplitude of segment in Volts (if vcmd) or Amps (if icmd). */
	double value_delta;                 /**< If type is TECELLA_STIMULUS_SEGMENT_DELTA, increment value by this delta after each iteration of the vcmd.  If type is TECELLA_STIMULUS_SEGMENT_RAMP, a negative value indicates a down ramp and a positive value indicates an up ramp.  */
	double duration;                    /**< Duration of segment in seconds. Note: Total duration for a TECELLA_STIMULUS_SEGMENT_RAMP segment is duration*ramp_steps. */
	double duration_delta;              /**< Increment duration by this delta after each iteration of the vcmd. Valid only if type is TECELLA_STIMULUS_SEGMENT_DELTA. */
	int ramp_steps;                     /**< The number of 1mV steps to take.  Number of ramp steps is limited to 256.  To specify up vs down, see value_delta.  Valid only if type is TECELLA_STIMULUS_SEGMENT_RAMP. */
} TECELLA_STIMULUS_SEGMENT;

/*****************************************//**
* tecella_stimulus_segment_ex
* Create an array of these and pass it to tecella_vcmd_set_ex().
* This version adds new features compared to the non "ex" version,
* but is more likely to change between versions
*/
typedef struct tecella_stimulus_segment_ex {
	TECELLA_STIMULUS_SEGMENT_TYPE type; /**< Type of segment. */
	double value;                       /**< Amplitude of segment in Volts (if vcmd) or Amps (if icmd). */
	double value_delta;                 /**< If type is TECELLA_STIMULUS_SEGMENT_DELTA, increment value by this delta after each iteration of the vcmd.  If type is TECELLA_STIMULUS_SEGMENT_RAMP, each ramp step is this big (check hw props for limits).  */
	double duration;                    /**< Duration of segment in seconds. Note: Total duration for a TECELLA_STIMULUS_SEGMENT_RAMP segment is duration*ramp_steps. */
	double duration_delta;              /**< Increment duration by this delta after each iteration of the vcmd. Valid only if type is TECELLA_STIMULUS_SEGMENT_DELTA. */
	int ramp_steps;                     /**< The number of 1mV steps to take.  Number of ramp steps is limited to 256.  To specify up vs down, see value_delta.  Valid only if type is TECELLA_STIMULUS_SEGMENT_RAMP. */
	int digital_out;                    /**< A mask for the digital out bits associated with this stimulus. */
	int slew;                           /**< Select which slew to use right before this segment is applied. */
} TECELLA_STIMULUS_SEGMENT_EX;


/**
 * @defgroup Callbacks Callbacks
 * TecellaAmp provides several callback mechanisms for error reporting and acquisition notifications.
 */
/*@{*/

#define CALL __cdecl

/** A callback to receive all errors emitted by the API.
Very useful for debugging and catching all errors if you accidentally forget to check a return code.
@param h The handle of the amplifier associated with the error.
@param e The error code.
@param msg The error message associated with the error code.
@see tecella_error_set_callback()
*/
typedef void (CALL *TECELLA_ERR_CB)(TECELLA_HNDL h, TECELLA_ERRNUM e, const wchar_t* msg);


/** A callback to recieve notifications of when newly acquired samples are available.
Please note that this callback runs in a dedicated acquisition callback thread and it is the user's responsibility to synchronize/lock any communication and memory access from this callback.
We recommend using the blocking tecella_acquire_read_i() functions without callbacks if possible.
@param h The handle of the amplifier the notification applies to.
@param channel The channel that new samples are available for.
@param samples_available The number of new samples available since the last time the callback was called for this channel.
@see tecella_acquire_set_callback()
*/
typedef void (CALL *TECELLA_ACQUIRE_CB)(TECELLA_HNDL h, int channel, unsigned int samples_available);


/** A callback to recieve notifications of when a stimulus has started.
Please note that this callback runs in a dedicated acquisition callback thread and it is the user's responsibility to synchronize/lock any communication and memory access from this callback.
We recommend using the blocking tecella_acquire_read_i() functions without callbacks if possible.
@param h The handle of the amplifier the notification applies to.
@param stimulus_index The stimulus that started playing.
@param timestamp The sample at which the stimulus started playing, where 0 is the timestamp of the first sample received after calling tecella_acquire_start().
@see tecella_stimulus_set_callback()
*/
typedef void (CALL *TECELLA_STIMULUS_CB)(TECELLA_HNDL h, int stimulus_index, unsigned long long timestamp);

/*@}*/

#ifdef __cplusplus
extern "C" {
#endif


/**
 * @defgroup Debug Debug and Logging
 */
/*@{*/

/** Turns debug logging on or off.
When enabled, all API function calls will be logged on entry and exit with their argument values.
If applicable, please include this log file in any bug reports.
@param logfile The filename of the debug log.  An empty filename "" turns debug off.
*/
DLLEXPORT TECELLA_ERRNUM CALL tecella_debug(const char *logfile);

/** Turns debug mode on using the filename "tecella_debug.txt"
Same as calling tecella_debug("tecella_debug.txt").
*/
DLLEXPORT TECELLA_ERRNUM CALL tecella_debug_default();

/*@}*/

/******************************************************************************
* Amplifier initialization and cleanup
******************************************************************************/
/**
 * @defgroup AmplifierInitCleanup Amplifier Initialization and Cleanup
 *
 * TecellaAmp makes it very easy to initialize the first available amplifier; just call tecella_initialize() with device_index=0 and you can start using the handle immediately.
 * Then, when your program is done using the amplifier, call tecella_finalize() to allow other programs to use the amplifier.
 *
 * Some amplifiers support multiple configurations, such as voltage clamp and current clamp modes.  To enumerate and switch between these configurations, see tecella_user_config_get() and tecella_user_config_set().
 *
 * More advanced features include amplifier enumeration (if you don't always want to use the first available amplifer) and amplifier pairing to control two or more amplifiers as if they were a single amplifier.
 * For amplifier enumeration, see tecella_enumerate() and tecella_enumerate_get().
 * For amplifier pairing, see tecella_initialize_pair().
 *
 * For some applications that use multiple processes, it may be useful if different processes can pass control of the amplifier around without having to do a full finalize and initialize.  For this purpose, you may use the tecella_finalize_to_file() and tecella_initialize_from_file() functions to quickly passes calibration info and the current state of the amplifier between processes.
 *
 */
/*@{*/

/** Enumerates all Tecella amplifiers currently connected to the computer.
Any subsequent calls to tecella_enumerate_descriptions() and tecella_initialize() will use the devices enumerated at the time of the last call to tecella_enumerate().
If a device has been connected after calling tecella_enumerate(), it will not affect initialization of the other amplifiers but will not have a corresponding device_index with which to initialize.
If a device has been disconnected after calling tecella_enumerate(), it will not affect initialization of the other amplifiers but will fail to initialize.
@param device_count A return pointer to hold the number of devices enumerated.
*/
DLLEXPORT TECELLA_ERRNUM CALL tecella_enumerate(int *device_count);

/** Returns the description of an amplifier as enumerated by the most recent call to tecella_enumerate().
@param device_index A number >= 0 and < device_count as returned by tecella_enumerate().
@param description A return pointer to a TECELLA_HW_PROPS structure that describes the device as indexed by device_index.
*/
DLLEXPORT TECELLA_ERRNUM CALL tecella_enumerate_get(int device_index, TECELLA_HW_PROPS *description);

/** Initializes the specified device and returns a handle for it.
tecella_initialize() will automatically call tecella_enumerate() if it hasn't already been called by ther user.
The default user configuration is used.  After initialization you may change the user configuration via tecella_user_config_get() and tecella_user_config_set().
@param h Pointer to a handle
@param device_index The device index corresponding to the most recent call to tecella_enumerate().
@post Upon success, h will point to a valid handle for the requested device.
*/
DLLEXPORT TECELLA_ERRNUM CALL tecella_initialize(TECELLA_HNDL *h, int device_index=0);

/** Takes two handles of already initilaized amplifiers and makes it look like a single amplifier.
This is only supported if both amplifiers are the same.
To comibine three or more amplifiers, you can chain multiple pairs together.
@param h Pointer to a handle
@param hA A handle previously returned by tecella_initialize()
@param hB A handle previously returned by tecella_initialize().  Must be different than h1.
@post Upon success, h will point to a valid handle for the requested device.
*/
DLLEXPORT TECELLA_ERRNUM CALL tecella_initialize_pair(TECELLA_HNDL *h, TECELLA_HNDL hA, TECELLA_HNDL hB);

/** Closes a device gracefully and deallocates any memory associated with it.
@param h A handle to an initialized device.
*/
DLLEXPORT TECELLA_ERRNUM CALL tecella_finalize(TECELLA_HNDL h);

/** Returns details for a specific amplifier configuration.
@param h A handle to an initialized device.
@param user_config A valid user configuration index.  Must be greater than or equal to 0 and less than the user_config_count field returned by tecella_get_hw_props() or tecella_enumerate_get().
@param description A return pointer to a TECELLA_HW_PROPS structure that describes the device if it were configured with user_config.
*/
DLLEXPORT TECELLA_ERRNUM CALL tecella_user_config_get(TECELLA_HNDL h, int user_config, TECELLA_HW_PROPS *description);

/** If the amplifier supports a user selectable configuration, it may be set here.
The configuration may only be set when not acquiring.
This function will switch the amplifier between IClamp and VClamp modes if supported by the hardware.
When in IClamp mode and supports_iclamp_enable is true, use tecella_chan_set_iclamp_enable() to swith between IClamp and Voltage Follower on a per-channel basis.
@param h A handle to an initialized device.
@param user_config A valid user configuration index.  Must be greater than or equal to 0 and less than the user_config_count field returned by tecella_get_hw_props() or tecella_enumerate_get().
*/
DLLEXPORT TECELLA_ERRNUM CALL tecella_user_config_set(TECELLA_HNDL h, int user_config);

/** If the amplifier supports a user selectable configuration, you may use this function to determine which configuration is currently used.
@param h A handle to an initialized device.
@param user_config A return pointer to hold the current user configuration index.
*/
DLLEXPORT TECELLA_ERRNUM CALL tecella_user_config_get_current(TECELLA_HNDL h, int *user_config);

/** Returns a handle for a previously intialized device that was finalized via tecella_finalize_to_file().
All state and calibration info is loaded from the file.
@param ph Pointer to a handle
@param filename Filename of the file created by tecella_finalize_
@post Upon success, h will point to a valid handle for the requested device.
*/
DLLEXPORT TECELLA_ERRNUM CALL tecella_initialize_from_file(TECELLA_HNDL *ph, char *filename);

/** Closes a device gracefully and deallocates any memory associated with it.
Saves state to a file so another process can call tecella_initialize_from_file() to quickly transfer ownership of the amplifier.
@param h A handle to an initialized device.
@param filename Filename of the file to which the state will be stored.
*/
DLLEXPORT TECELLA_ERRNUM CALL tecella_finalize_to_file(TECELLA_HNDL h, char *filename);

/*@}*/


/******************************************************************************
* Various amplifier calibration functions
******************************************************************************/

/**
 * @defgroup AmplifierCalibration Amplifier Calibration
 *
 * These functions help calibrate various parameters of the amplifier to account for the various hardware component tolerances.
 *
 * Call tecella_calibrate_all() to calibrate the amplifier, then call tecella_calibrate_save() to save the calibration info of the amplifier.
 * Then, in the future, you can just call tecella_calibrate_load() after tecella_initialize() to load the amplifier's calibration info.
 *
 * Other functions documented below are available for more fine-grained control of the calibrations.
 */
/*@{*/

/** Calibrates the amplifier for various offsets and scale factors.
Equivalent of calling tecella_auto_calibrate() and tecella_auto_scale() individually for each user_config separately.
@param h A handle to an initialized device.
*/
DLLEXPORT TECELLA_ERRNUM CALL tecella_calibrate_all(TECELLA_HNDL h);

/** Saves the current offset and scale calibration settings to a file.
@param h A handle to an initialized device.
@param foldername Folder in which to save the calibration file.
@param filename The filename of the configuration file. If no filename is specified or if the pointer is NULL, filename will be "amplifier_calibration_<serial_number>".
*/
DLLEXPORT TECELLA_ERRNUM CALL tecella_calibrate_save(TECELLA_HNDL h, const char *foldername, const char *filename=0);

/** Loads  offset and scale calibration settings from a file.
@param h A handle to an initialized device.
@param foldername Folder in which to save the calibration file.
@param filename The filename of the configuration file. If no filename is specified or if the pointer is NULL, filename will be "amplifier_calibration_<serial_number>".
*/
DLLEXPORT TECELLA_ERRNUM CALL tecella_calibrate_load(TECELLA_HNDL h, const char *foldername, const char *filename=0);

/** Internally calibrates the gain settings to be within the tolerance speced for the amplifier.
Some gain feedback resistors have large tolerances and must be calibrated to be within specification.
Only channels that are enabled by tecella_acquire_enable_channel() will be affected by a call to this function.
You should only need need to run this once after initialization.
This function may not be used while acquiring.
@param h A handle to an initialized device.
@param enable Indicates whether we are enabling/disabling the auto scale.  If disabled, the ideal scales will be used, whether or not they are correct.
@param unused_stimulus_index An unused stimulus that tecella_auto_scale can use.  Only associated channels are calibrated.
*/
DLLEXPORT TECELLA_ERRNUM CALL
tecella_auto_scale(TECELLA_HNDL h, bool enable, int unused_stimulus_index=0);

/** Enables or disables the auto scale used from the most recent call to tecella_auto_scale().
Does not perform any calibration.  If the scale hasn't been calibrated yet, this function has no effect.
@param h A handle to an initialized device.
@param enable Indicates whether we are enabling/disabling the auto scale.  If disabled, the ideal scales will be used, whether or not they are correct.
*/
DLLEXPORT TECELLA_ERRNUM CALL
tecella_auto_scale_enable(TECELLA_HNDL h, bool enable);

DLLEXPORT TECELLA_ERRNUM CALL
tecella_auto_scale_enable_get(TECELLA_HNDL h, bool *enable);

/** This calibrates any input offsets due to component tolerances WITHIN the amplifier.
Make sure source is set to OPEN to isolate any external interference.
You should only need need to run this once after initialization.
A 0mV stimulus is played to establish a "tare" value for acquisitions on a per-channel basis.
Subsequent acquisitions are adjusted by these per-channel tare values.
Only channels that are enabled by tecella_acquire_enable_channel() will be affected by a call to this function.
This function may not be used while acquiring.
@param h A handle to an initialized device.
@param enable Indicates whether we are enabling/disabling the offset.
@param unused_stimulus_index An unused stimulus that tecella_auto_calibrate can use.  Only associated channels are calibrated.
*/
DLLEXPORT TECELLA_ERRNUM CALL
tecella_auto_calibrate(TECELLA_HNDL h, bool enable, int unused_stimulus_index=0);

/** Enables or disables the auto calibration used from the most recent call to tecella_auto_calibrate().
Does not perform any calibration.  If the offsets haven't been calibrated yet, this function has no effect.
@param h A handle to an initialized device.
@param enable Indicates whether we are enabling/disabling auto calibration.  If disabled, the ideal scales will be used, whether or not they are correct.
*/
DLLEXPORT TECELLA_ERRNUM CALL
tecella_auto_calibrate_enable(TECELLA_HNDL h, bool enable);

DLLEXPORT TECELLA_ERRNUM CALL
tecella_auto_calibrate_enable_get(TECELLA_HNDL h, bool *enable);

/** Returns the current offset added to the incomming waveform.
To get the actual units of the offset multiply by the scale returned by tecella_acquire_i2d_scale().
@param h A handle to an initialized device.
@param channel The channel for which to get the calibration of.
@param offset A pointer for the returned offset.
*/
DLLEXPORT TECELLA_ERRNUM CALL
tecella_auto_calibrate_get(TECELLA_HNDL h, int channel, int *offset);

/** Manually sets the offsets added to the incomming waveform.
To get the actual units of the offset multiply by the scale returned by tecella_acquire_i2d_scale().
@param h A handle to an initialized device.
@param channel The channel for which to get the calibration of.
@param offset A pointer for the returned offset.
*/
DLLEXPORT TECELLA_ERRNUM CALL
tecella_auto_calibrate_set(TECELLA_HNDL h, int channel, int offset);

/*@}*/


/******************************************************************************
* Various properties of the library, hardware, and supported settings
******************************************************************************/

/**
 * @defgroup AmplifierProperties Amplifier Properties
 *
 * These functions allow you to get various properties of the library and amplifier.  For example: version numbers, channel counts, compensation ranges/step-sizes/units, and display labels.
 *
 * The amplifier's properties can change, so these functions should be called after tecella_initialize() and whenever you change the amplifier configuration via tecella_user_config_set().
 *
 */
/*@{*/

/** Retreives the current version of the DLL being used.
@param props A pointer to the library properties.
*/
DLLEXPORT TECELLA_ERRNUM CALL tecella_get_lib_props(TECELLA_LIB_PROPS *props);

/** Retreives properties of the amplifier.
@param h A handle to an initialized device.
@param props A pointer to the hardware/firmware properties.
*/
DLLEXPORT TECELLA_ERRNUM CALL tecella_get_hw_props(TECELLA_HNDL h, TECELLA_HW_PROPS *props);

/** Retreives the extended properties of the amplifier.
@param h A handle to an initialized device.
@param props A pointer to the extended hardware/firmware properties.
*/
DLLEXPORT TECELLA_ERRNUM CALL tecella_get_hw_props_ex_01(TECELLA_HNDL h, TECELLA_HW_PROPS_EX_01 *props);

/** Retreives properties of the requested register for a given device.
@param h A handle to an initialized device.
@param r The register we'd like the properties of.
@param props A pointer to the register properties.
*/
DLLEXPORT TECELLA_ERRNUM CALL tecella_get_reg_props(TECELLA_HNDL h, TECELLA_REGISTER r, TECELLA_REG_PROPS *props);

/** Retreives a label for a specific gain choice for use in a GUI.
This will provide more useful information to the user about which gain is currently selected specific to their device.
@param h A handle to an initialized device.
@param gain_index The gain choice.
@param label A return argument for the label string.
*/
DLLEXPORT TECELLA_ERRNUM CALL tecella_get_gain_label(TECELLA_HNDL h, int gain_index, const wchar_t **label);
DLLEXPORT TECELLA_ERRNUM CALL tecella_get_gain1_label(TECELLA_HNDL h, int gain_index, const wchar_t **label);
DLLEXPORT TECELLA_ERRNUM CALL tecella_get_gain2_label(TECELLA_HNDL h, int gain_index, const wchar_t **label);

/** Retreives a label for a specific source choice for use in a GUI.
This will provide more useful information to the user about which source is selected specific to their device.
@param h A handle to an initialized device.
@param source_index The gain choice.
@param label A return argument for the label string.
*/
DLLEXPORT TECELLA_ERRNUM CALL tecella_get_source_label(TECELLA_HNDL h, int source_index, const wchar_t **label);

/** Retreives a label for the specified slew choice.
This will provide more useful information to the user about which slew is selected specific to their device.
@param h A handle to an initialized device.
@param slew_index The slew choice.
@param label A return argument for the label string.
*/
DLLEXPORT TECELLA_ERRNUM CALL tecella_get_slew_label(TECELLA_HNDL h, int slew_index, const wchar_t **label);

/*@}*/


/******************************************************************************
* Error handling 
******************************************************************************/

/**
 * @defgroup ErrorHandling Error Handling
 *
 * Almost all functions in this API return a TECELLA_ERRNUM error code.
 * tecella_error_message() helps translate the error code into a meaningful message that can be displayed to the user.
 * tecella_error_set_callback() can help you make sure you never miss an error returned by the API.
 */
/*@{*/

/** Retreives the message string associated with an error value.
@param errnum The error returned by any of the API functions.
@returns The message string.
*/
DLLEXPORT const wchar_t* CALL tecella_error_message(TECELLA_ERRNUM errnum);

/** Sets a callback function to be called upon an error.
Very useful for debugging and catching all errors if you accidentally forget to check a return code.
@param h A handle to an initialized device.
@param f The error callback function.
*/
DLLEXPORT TECELLA_ERRNUM CALL tecella_error_set_callback(TECELLA_HNDL h, TECELLA_ERR_CB f);

/*@}*/


/******************************************************************************
* System Monitor and Diagnostics
******************************************************************************/

/**
 * @defgroup Diagnostics Amplifier Diagnostics
 *
 * All Tecella amplifiers are equiped with a system monitor feature that helps monitor the amplifier's health by measuring various voltages of the system.
 * To use this feature, call the tecella_system_monitor_run() function followed by muliple calls to tecella_system_monitor_get().
 *
 * Various other diagnostics functions are no longer supported and are marked deprecated in the documentation.
 */
/*@{*/

/** Runs a quick tests on the system, such as system voltage and power measurments.
Retreive results by using tecella_system_monitor_get().  Cannot be used during acquisition.
@param h A handle to an initialized device.
@param result_count A pointer to an int that will hold how many results can be retreived by calling tecella_system_monitor_get().
@param results_per_controller A helper variable that indicates how many results will belong to the controller board.
@param results_per_slot A helper variable that indicates how many results will belong to each daughter board.  If 0, there are not daughter boards.
*/
DLLEXPORT TECELLA_ERRNUM CALL tecella_system_monitor_run(TECELLA_HNDL h, int *result_count, int *results_per_controller, int *results_per_slot);

/** Retreives results from the most recent call to tecella_system_monitor_run().
Cannot be used during acquisition.
@param h A handle to an initialized device.
@param result_index An index to a result between 0 and result_count as returned by tecella_system_monitor_run.
@param result A pointer to a TECELLA_SYSTEM_MONITOR_RESULT structure that will contain the result on return.
*/
DLLEXPORT TECELLA_ERRNUM CALL tecella_system_monitor_get(TECELLA_HNDL h, int result_index, TECELLA_SYSTEM_MONITOR_RESULT *result);


/** Tells the dynamic monitor which point to monitor.
Dynamic monitor is when one of the channels records a monitor point at the same sampling rate as all the other channels during acquisition.
@deprecated Do not use this function.
@param h A handle to an initialized device.
@param monitor_index Indicates which point to monitor.
*/
DLLEXPORT TECELLA_ERRNUM CALL
tecella_system_monitor_dynamic_set(TECELLA_HNDL h, int monitor_index);

/** Performs hardware diagnostics / sanity checks to make sure hardware is functional.
To get actual warning/error messages, call tecella_diagnostics_run_get_pass() or tecella_diagnostics_get_failure().
@deprecated Do not use this function.
@param h A handle to an initialized device.
@param pass_count A return argument for the number of warnings reported.
@param fail_count A return argument for the number of errors reported.
*/
DLLEXPORT TECELLA_ERRNUM CALL tecella_diagnostics_run(TECELLA_HNDL h, int *pass_count, int *fail_count);

/** Returns messages of passing tests after running tecella_diagnostics_run().
@deprecated Do not use this function.
@param h A handle to an initialized device.
@param pass_index An index in the range [0,pass_count), as returned by tecella_diagnostics_run().
@param msg A return argument for the null-terminated text describing the test.  Pointer remains valid until the next call to tecella_diagnostics_run() with the same handle.
*/
DLLEXPORT TECELLA_ERRNUM CALL tecella_diagnostics_get_pass(TECELLA_HNDL h, int pass_index, const wchar_t **msg);

/** Returns messages of failed tests after running tecella_diagnostics_run().
@deprecated Do not use this function.
@param h A handle to an initialized device.
@param fail_index An index in the range [0,fail_count), as returned by tecella_diagnostics_run().
@param msg A return argument for the null-terminated text of the failure.  Pointer remains valid until the next call to tecella_diagnostics_run() with the same handle.
*/
DLLEXPORT TECELLA_ERRNUM CALL tecella_diagnostics_get_failure(TECELLA_HNDL h, int fail_index, const wchar_t **msg);

/*@}*/


/******************************************************************************
* Utility IO and Telegraphs
******************************************************************************/

/**
 * @defgroup UtilityIO Utility IO & Telegraphs
 *
 * Various functions for controling utility DACs and digital IOs.
 * Useful for controlling external devices via the amplifier.
 *
 */
/*@{*/


/** Sets the utility DAC voltage.
*/
DLLEXPORT TECELLA_ERRNUM CALL tecella_utility_dac_set(TECELLA_HNDL h, double value, int index=0);


/** Sets the utility trigger out. 
*/
DLLEXPORT TECELLA_ERRNUM CALL tecella_utility_trigger_out(TECELLA_HNDL h, int index);


/** Sets the stimulus index for stimulus-only outputs.
Currently, only supported by Richmond amplifiers.
*/
DLLEXPORT TECELLA_ERRNUM CALL tecella_utility_set_stimulus(TECELLA_HNDL h, int channel, int stimulus_index);


/** Enables or disables the telegraph outputs of the amplifier.

Telegraphs are output voltages from an amplifier to a digitizer that
tell the digitizer and acquisition software the current gain selected
and the cuttoff frequency of the low pass filter.  This helps the
acquisition software know what sampling rates are good and how to
scale the amplified signal to the proper units.

The telegraph feature is only useful when the amplifier is connected
to an external digitizer instead of using the digitizer that comes
integrated with the amplifier.

Very few amplifiers support telegraphs, such as some models of the Pico.
To see if an amplifier supports telegraphs, check the
TECELLA_HW_PROPS_EX_01.supports_telegraphs field.

When telegraphs are enabled, some of the utility dacs and digital IO's
will come under the control of the amplifier and cannot be used by the user
for other puposes.  Refer to the amplifier's documentation to see which
utility IO's are used for telegraphs.
@param h A handle to an initialized device.
@param enable If true, enables telegraph outputs.  If false, disables telegraphs and frees utility IO's for use.
*/
DLLEXPORT TECELLA_ERRNUM CALL
tecella_telegraph_enable(TECELLA_HNDL h, bool enable);

/*@}*/


/******************************************************************************
* Per-channel settings
******************************************************************************/

/**
 * @defgroup ChannelSettings Per-channel settings
 *
 * These functions get and set properties that are controlled independently for each channel of the amplifier.
 * - High level settings include: the source, gain, stimulus select, and iclamp enable.
 * - Analog filters include: bessel low pass filter, and a high pass filter.
 * - Analog compensations include: capacitance, leak, JP, and Rseries compensations.
 * - Digital compensations include: leak.
 *
 * See tecella_get_hw_props() and tecella_get_reg_props() to see what settings are supported by the current amplifier and user configuration.
 *
 */
/*@{*/

/** Chooses which source to measure from for a given channel.
@param h A handle to an initialized device.
@param channel The channel to change.  TECELLA_ALLCHAN can be used as a shortcut here.
@param choice Which source to use.  See tecella_get_hw_props() for valid values.  See tecella_get_source_label() for what a value means.
*/
DLLEXPORT TECELLA_ERRNUM CALL tecella_chan_set_source(TECELLA_HNDL h, int channel, int choice);

/** Get the currently selected source for a given channel.
@param h A handle to an initialized device.
@param channel A channel.  TECELLA_ALLCHAN may not be used as a shortcut here.
@param choice Returns which source is selected.  See tecella_get_hw_props() for valid values.  See tecella_get_source_label() for what a value means.
*/
DLLEXPORT TECELLA_ERRNUM CALL tecella_chan_get_source(TECELLA_HNDL h, int channel, int *choice);

/** Chooses which gain to use for a given channel.
@param h A handle to an initialized device.
@param channel The channel to change.  TECELLA_ALLCHAN can be used as a shortcut here.
@param choice Which gain to use.  See tecella_get_hw_props() for valid values.  See tecella_get_gain_label() for what a value means.
*/
DLLEXPORT TECELLA_ERRNUM CALL tecella_chan_set_gain(TECELLA_HNDL h, int channel, int choice);
DLLEXPORT TECELLA_ERRNUM CALL tecella_chan_set_gain1(TECELLA_HNDL h, int channel, int choice);
DLLEXPORT TECELLA_ERRNUM CALL tecella_chan_set_gain2(TECELLA_HNDL h, int channel, int choice);

/** Get the currently selected gain for a given channel.
@param h A handle to an initialized device.
@param channel A channel.  TECELLA_ALLCHAN may not be used as a shortcut here.
@param choice Returns which gain is selected.  See tecella_get_hw_props() for valid values.  See tecella_get_source_label() for what a value means.
*/
DLLEXPORT TECELLA_ERRNUM CALL tecella_chan_get_gain(TECELLA_HNDL h, int channel, int *choice);
DLLEXPORT TECELLA_ERRNUM CALL tecella_chan_get_gain1(TECELLA_HNDL h, int channel, int *choice);
DLLEXPORT TECELLA_ERRNUM CALL tecella_chan_get_gain2(TECELLA_HNDL h, int channel, int *choice);

/** Chooses which stimulus to use for a given channel.
Applicable only for devices that support multiple stimuli [see tecella_get_hw_props()], otherwise the only choice is '0'.
@param h A handle to an initialized device.
@param channel The channel to change.  TECELLA_ALLCHAN can be used as a shortcut here.
@param choice Which stimulus to use.  See tecella_get_hw_props() for valid values.  See tecella_get_gain_label() for what a value means.
*/
DLLEXPORT TECELLA_ERRNUM CALL tecella_chan_set_stimulus(TECELLA_HNDL h, int channel, int choice);

/** Get the currently selected stimulus for a given channel.
Applicable only for devices that support multiple stimuli [see tecella_get_hw_props()].
@param h A handle to an initialized device.
@param channel A channel.  TECELLA_ALLCHAN may not be used as a shortcut here.
@param choice Returns which gain is selected.  See tecella_get_hw_props() for valid values.  See tecella_get_source_label() for what a value means.
*/
DLLEXPORT TECELLA_ERRNUM CALL tecella_chan_get_stimulus(TECELLA_HNDL h, int channel, int *choice);

/** Enables/disables the frequency boost for a particular channel.
@param h A handle to an initialized device.
@param channel The channel to change.  TECELLA_ALLCHAN can be used as a shortcut here.
@param enable Indicates whether to enable or disable frequency boost.
*/
DLLEXPORT TECELLA_ERRNUM CALL tecella_chan_set_boost_enable(TECELLA_HNDL h, int channel, bool enable);

/** Returns whether frequency boost is enabled/disabled for a particular channel.
@param h A handle to an initialized device.
@param channel The channel to change.  TECELLA_ALLCHAN may not be used as a shortcut here.
@param enable Indicates whether frequency boost is enabled or disabled.
*/
DLLEXPORT TECELLA_ERRNUM CALL tecella_chan_get_boost_enable(TECELLA_HNDL h, int channel, bool *enable);

/** Returns whether frequency boost is supported
@param h A handle to an initialized device.
@param supported Indicates whether frequency boost is supported.
*/
DLLEXPORT TECELLA_ERRNUM CALL tecella_chan_get_boost_enable_supported(TECELLA_HNDL h, bool *supported);

/** Enables/disables the iclamp for a particular channel.
Note: Using tecella_user_config_set() can switch all channels between various modes, including VClamp and IClamp.
This function is to be used within an IClamp user config when supports_iclamp_enable is true.
Within an IClamp user config, this function can enable/disable IClamp on a per-channel basis.
The channels with IClamp disabled will behave as voltage followers.
@param h A handle to an initialized device.
@param channel The channel to change.  TECELLA_ALLCHAN can be used as a shortcut here.
@param enable Indicates whether to enable or disable the iclamp.
*/
DLLEXPORT TECELLA_ERRNUM CALL tecella_chan_set_iclamp_enable(TECELLA_HNDL h, int channel, bool enable);

/** Returns whether iclamp is enabled/disabled for a particular channel.
@param h A handle to an initialized device.
@param channel The channel to change.  TECELLA_ALLCHAN may not be used as a shortcut here.
@param enable Indicates whether the iclamp is enabled or disabled.
*/
DLLEXPORT TECELLA_ERRNUM CALL tecella_chan_get_iclamp_enable(TECELLA_HNDL h, int channel, bool *enable);

/** Enables/disables the vcmd for a particular channel.
Only valid for in voltage clamp modes.  When the vcmd is disabled, voltage will be clamped to 0V.
@param h A handle to an initialized device.
@param channel The channel to change.  TECELLA_ALLCHAN can be used as a shortcut here.
@param enable Indicates whether to enable or disable the vcmd.
*/
DLLEXPORT TECELLA_ERRNUM CALL tecella_chan_set_vcmd_enable(TECELLA_HNDL h, int channel, bool enable);

/** Returns whether the vcmd is enabled/disabled for a particular channel.
@param h A handle to an initialized device.
@param channel The channel to change.  TECELLA_ALLCHAN may not be used as a shortcut here.
@param enable Indicates whether the vcmd is enabled or disabled.
*/
DLLEXPORT TECELLA_ERRNUM CALL tecella_chan_get_vcmd_enable(TECELLA_HNDL h, int channel, bool *enable);

/** Sets a register (property) of a channel.
See tecella_reg_props(), to determine if a particular register is supported by the current hardware and to retreive other properties such as valid value ranges and precision.
@param h A handle to an initialized device.
@param r Which register to change.
@param channel A channel.  TECELLA_ALLCHAN can be used as a shortcut here.
@param value The value to change the register to.
*/
DLLEXPORT TECELLA_ERRNUM CALL tecella_chan_set(TECELLA_HNDL h, TECELLA_REGISTER r, int channel, double value);

/** Gets a register (property) of a channel.
See tecella_reg_props(), to determine if a particular register is supported by the current hardware and to retreive other properties such as valid value ranges and precision.
@param h A handle to an initialized device.
@param r Which register to get.
@param channel A channel.  TECELLA_ALLCHAN may not be used as a shortcut here.
@param value Returns the value of the register..
*/
DLLEXPORT TECELLA_ERRNUM CALL tecella_chan_get(TECELLA_HNDL h, TECELLA_REGISTER r, int channel, double *value);

/** A convenience function for tecella_chan_set() that takes in a percent instead of an actual value. */
DLLEXPORT TECELLA_ERRNUM CALL tecella_chan_set_pct(TECELLA_HNDL h, TECELLA_REGISTER r, int channel, double pct);

/** A convenience function for tecella_chan_get() that returns a percent instead of an actual value. */
DLLEXPORT TECELLA_ERRNUM CALL tecella_chan_get_pct(TECELLA_HNDL h, TECELLA_REGISTER r, int channel, double *pct);

/** Enables/disables a register (property) of a channel.
See tecella_reg_props(), to determine if a particular register can be enabled/disabled.
@param h A handle to an initialized device.
@param r Which register to determine enable/disable.
@param channel A channel.  TECELLA_ALLCHAN may be used as a shortcut here.
@param enable If true, enables the register.  Disables if false.
*/
DLLEXPORT TECELLA_ERRNUM CALL tecella_chan_set_enable(TECELLA_HNDL h, TECELLA_REGISTER r, int channel, bool enable);

/** Gets if a register (property) of a channel is enabled.
See tecella_reg_props(), to determine if a particular register can be enabled/disabled.
@param h A handle to an initialized device.
@param r Which register to determine is enabled or not.
@param channel A channel.  TECELLA_ALLCHAN may not be used as a shortcut here.
@param enable Returns if the register is enabled or not.
*/
DLLEXPORT TECELLA_ERRNUM CALL tecella_chan_get_enable(TECELLA_HNDL h, TECELLA_REGISTER r, int channel, bool *enable);

/** Chooses a cuttoff frequency for the bessel filter.
Note that an integer value is taken in to re-enforce the fact that the bessel filter cuttoff frequency is a non-linear function of the value being passed in.
To see what frequency a choice corresponds to, use tecella_bessel_value2freq() / tecella_bessel_freq2value().
See tecella_get_hw_props(), to determine if bessel is supported and to see how many cuttoff frequency choices there are.
@param h A handle to an initialized device.
@param channel A channel.  TECELLA_ALLCHAN may be used as a shortcut here.
@param value Which cuttoff frequency to select.
*/
DLLEXPORT TECELLA_ERRNUM CALL tecella_chan_set_bessel(TECELLA_HNDL h, int channel, int value);

/** Gets the cuttoff frequency choice for the bessel filter.
Note that an integer value is taken in to re-enforce the fact that the bessel filter cuttoff frequency is a non-linear function of the value being passed in.
To see what frequency a choice corresponds to, use tecella_bessel_value2freq() / tecella_bessel_freq2value().
See tecella_get_hw_props(), to determine if bessel is supported and to see how many cuttoff frequency choices there are.
@param h A handle to an initialized device.
@param channel A channel.
@param value Which cuttoff frequency is selected.
*/
DLLEXPORT TECELLA_ERRNUM CALL tecella_chan_get_bessel(TECELLA_HNDL h, int channel, int *value);

/** Returns the frequency of a bessel filter cuttoff choice. */
DLLEXPORT TECELLA_ERRNUM CALL tecella_bessel_value2freq(TECELLA_HNDL h, int value, double *kHz);

/** Returns the best choice for a bessel filter cuttoff frequency. */
DLLEXPORT TECELLA_ERRNUM CALL tecella_bessel_freq2value(TECELLA_HNDL h, double kHz, int *value);

/** Chosses the cuttoff frequency for the high pass filter.
Note that an integer value is taken in to re-enforce the fact that the cuttoff frequency is a non-linear function of the value being passed in.
To see what frequency a choice corresponds to, use tecella_hpf_value2freq() / tecella_hpf_freq2value().
See tecella_get_hw_props(), to determine if a high pass filter is supported and to see how many cuttoff frequency choices there are.
@param h A handle to an initialized device.
@param channel A channel.  TECELLA_ALLCHAN may be used as a shortcut here.
@param value Which cuttoff frequency to select.
*/
DLLEXPORT TECELLA_ERRNUM CALL
tecella_chan_set_hpf(TECELLA_HNDL h, int channel, int value);

/** Gets the cuttoff frequency choice for the high pass filter.
@param h A handle to an initialized device.
@param channel A channel.
@param value Which cuttoff frequency is selected.
*/
DLLEXPORT TECELLA_ERRNUM CALL
tecella_chan_get_hpf(TECELLA_HNDL h, int channel, int *value);

/** Returns the frequency of a high pass filter cuttoff choice. */
DLLEXPORT TECELLA_ERRNUM CALL
tecella_hpf_value2freq(TECELLA_HNDL h, int choice, double *Hz);

/** Returns the best choice for a high pass filter cuttoff frequency. */
DLLEXPORT TECELLA_ERRNUM CALL
tecella_hpf_freq2value(TECELLA_HNDL h, double Hz, int *choice);

/** Sets digital leak compensation in Ohms^-1.
To calculate the total leak compensation applied, you may add digital_leak to the analog leak register value and invert the combined value.
Note: as of 10/19/2009 this function uses Ohms whereas the analog register uses MOhms.
@param h A handle to an initialized device.
@param channel The channel you want the leak compensation of.
@param digital_leak The amount of digital leak to apply in Ohms^-1.
*/
DLLEXPORT TECELLA_ERRNUM CALL
tecella_chan_set_digital_leak( TECELLA_HNDL h, int channel, double digital_leak );

/** Returns the equivalent digital leak compensation in Ohms^-1.
To calculate the total leak compensation applied, you may add digital_leak to the analog leak register value and invert the combined value.
Note: as of 10/19/2009 this function uses Ohms whereas the analog register uses MOhms.
@param h A handle to an initialized device.
@param channel The channel you want the leak compensation of.
@param digital_leak The amount of digital leak applied in Ohms^-1.
*/
DLLEXPORT TECELLA_ERRNUM CALL
tecella_chan_get_digital_leak( TECELLA_HNDL h, int channel, double *digital_leak );

/** Sets whether digital leak is enabled or disabled.
@param h A handle to an initialized device.
@param channel The channel you want the leak compensation of.
@param enable Set to false if you wish to disable digital leak, true if you wish to enable digital leak.
*/
DLLEXPORT TECELLA_ERRNUM CALL
tecella_chan_set_digital_leak_enable( TECELLA_HNDL h, int channel, bool enable );

/** Gets whether digital leak is enabled or disabled.
@param h A handle to an initialized device.
@param channel The channel you want the leak compensation of.
@param enabled Returns whether digital leak is enabled or not.
*/
DLLEXPORT TECELLA_ERRNUM CALL
tecella_chan_get_digital_leak_enable( TECELLA_HNDL h, int channel, bool *enabled );

/*@}*/


/******************************************************************************
* Stimulus
******************************************************************************/

/**
 * @defgroup Stimulus Stimulus
 *
 * These functions allow you to control the holding level of the stimulus and the sequence of stimulus segments to play during acquisition.
 * Helper functions to get the expected number of samples associated with a stimulus are available.
 *
 * Additionally, ZAP functionality is accessed via tecella_stimulus_zap().
 *
 */
/*@{*/

/** Programs a simple holding voltage into the hardware.
The holding voltage is defined as the voltage that is output whenever the stimulus is not playing.
@param h A handle to an initialized device.
@param value The requested holding voltage/current in Volts/Amps.  Must be within the valid range for a stimulus segment.
@param index The index of the stimulus to set the value of.
*/
DLLEXPORT TECELLA_ERRNUM CALL tecella_stimulus_set_hold( TECELLA_HNDL h, double value, int index=0 );

/** Programs a stimulus into the hardware.
When the stimulus is played it will iterate through all its segments.  Once it finishes or is stopped, the output will go back to the holding voltage as defined by tecella_stimulus_set_hold().
Note: Currently, a stimulus must have 3 or more segments.
@param h A handle to an initialized device.
@param segments A pointer to an array of segments that define the stimulus.
@param segment_count The number of segments to which segments points.  A stimulus must have 3 or more segments.
@param delta_count The number of times to increment a segment by the step value.  After delta_count repeats, the segment goes back to it's initial value.  Must be >=1.
@param repeat_count The number of times the entire stimulus will repeat.  Must be >=1.
@param index Specifies which stimulus to program if multiple stimuli are supported on the device.
*/
DLLEXPORT TECELLA_ERRNUM CALL tecella_stimulus_set( TECELLA_HNDL h, TECELLA_STIMULUS_SEGMENT *segments, int segment_count,
											        int delta_count=1, int repeat_count=1, int index=0 );

/** Programs a stimulus into the hardware.
This function has more functionality than the "non ex" version, but is more subject to change in future versions of the API.
When the stimulus is played it will iterate through all its segments.  Once it finishes or is stopped, the output will go back to the holding voltage as defined by tecella_stimulus_set_hold().
Note: Currently, a stimulus must have 3 or more segments.
@param h A handle to an initialized device.
@param segments A pointer to an array of segments that define the stimulus.
@param segment_count The number of segments to which segments points.  A stimulus must have 3 or more segments.
@param delta_count The number of times to increment a segment by the step value.  After delta_count repeats, the segment goes back to it's initial value.  Must be >=1.
@param repeat_count The number of times the entire stimulus will repeat.  Must be >=1.
@param index Specifies which stimulus to program if multiple stimuli are supported on the device.
*/
DLLEXPORT TECELLA_ERRNUM CALL tecella_stimulus_set_ex( TECELLA_HNDL h, TECELLA_STIMULUS_SEGMENT_EX *segments, int segment_count,
															int delta_count=1, int repeat_count=1, int index=0 );

/** Retreives the currently programed stimulus.
Note: due to precision constraints of the hardware, the stimulus returned by tecella_stimulus_get() may not exactly match the stimulus passed into tecella_stimulus_set().
@param h A handle to an initialized device.
@param segments A pointer to an array of pre-allocated segments.
@param segments_max The maximum size of the array pointed to by segments, so the API does not write into unallocated memory.
@param segments_in_stimulus The actual number of segments in the stimulus.
@param delta_count The number of times to increment a segment by the step value.  After delta_count repeats, the segment goes back to it's initial value.  Must be >=1.
@param repeat_count The number of times the entire stimulus will repeat.  Must be >=1.
@param index Specifies which stimulus to program if multiple stimuli are supported on the device.
*/
DLLEXPORT TECELLA_ERRNUM CALL tecella_stimulus_get( TECELLA_HNDL h, TECELLA_STIMULUS_SEGMENT *segments, int segments_max, int *segments_in_stimulus,
											        int *delta_count, int *repeat_count, int index=0 );

/** Retreives the currently programed stimulus.
Note: This function has more functionality than the "non ex" version, but is more subject to change in future versions of the API.
Note: due to precision constraints of the hardware, the stimulus returned by tecella_stimulus_get() may not exactly match the stimulus passed into tecella_stimulus_set().
@param h A handle to an initialized device.
@param segments A pointer to an array of pre-allocated segments.
@param segments_max The maximum size of the array pointed to by segments, so the API does not write into unallocated memory.
@param segments_in_stimulus The actual number of segments in the stimulus.
@param delta_count The number of times to increment a segment by the step value.  After delta_count repeats, the segment goes back to it's initial value.  Must be >=1.
@param repeat_count The number of times the entire stimulus will repeat.  Must be >=1.
@param index Specifies which stimulus to program if multiple stimuli are supported on the device.
*/
DLLEXPORT TECELLA_ERRNUM CALL tecella_stimulus_get_ex( TECELLA_HNDL h, TECELLA_STIMULUS_SEGMENT_EX *segments, int segments_max, int *segments_in_stimulus,
															int *delta_count, int *repeat_count, int index=0 );

/** DEPCRICATED
This function is no longer supported and will be removed in the next majof version of the API.  Use ex versions of the stimulus functions instead.
Sets the slew rate of the stimulus / how fast the edges rise and fall.
@param h A handle to an initialized device.
@param choice 0 is the fastest, then it gets slower as the choice increases.  The max value for this parameter depends on the connected hardware.  Each increment may also not be linear.
@param index The stimulus index to change the slew rate of.
*/
DLLEXPORT TECELLA_ERRNUM CALL tecella_stimulus_set_slew( TECELLA_HNDL h, int choice, int index=0 );


/** Sets the stimulus callback.
The stimulus callback will be called whenever a stimulus has started during acquisition.
The stimulus callback is called in the same thread as the acquire callback.
Notification of stimulus start is guaranteed to occur before notification of any associated samples.
@param h A handle to an initialized device.
@param f The stimulus callback function.
*/
DLLEXPORT TECELLA_ERRNUM CALL tecella_stimulus_set_callback( TECELLA_HNDL h, TECELLA_STIMULUS_CB f );

/** Returns the number of samples to expect for a given stimulus, including all delta iterations and repeat iterations.
@param h A handle to an initialized device.
@param index A stimulus index.
@param sample_period The sample period in seconds.
@returns The number of samples in the stimulus, including all repeat counts and delta counts.
*/
DLLEXPORT unsigned long long CALL tecella_stimulus_index_sample_count( TECELLA_HNDL h, int index, double sample_period );

/** Returns the number of samples to expect for a given stimulus, including all delta iterations and repeat iterations.
@param h A handle to an initialized device.
@param segments A pointer to an array of segments that define the stimulus.
@param segment_count The number of segments to which segments points.
@param delta_count The number of times to increment a segment by the step value.  After delta_count repeats, the segment goes back to it's initial value.  Must be >=1.
@param repeat_count The number of times the entire stimulus will repeat.  Must be >=1.
@param sample_period The sample period in seconds used when acquiring.  Be sure to manually include any 
*/
DLLEXPORT unsigned long long CALL tecella_stimulus_sample_count( TECELLA_HNDL h, TECELLA_STIMULUS_SEGMENT *segments, int segment_count,
                                                                 int delta_count, int repeat_count, double sample_period );

/** Returns the number of samples to expect for a given stimulus, including all delta iterations and repeat iterations.
Note: This function has more functionality than the "non ex" version, but is more subject to change in future versions of the API.
@param h A handle to an initialized device.
@param segments A pointer to an array of segments that define the stimulus.
@param segment_count The number of segments to which segments points.
@param delta_count The number of times to increment a segment by the step value.  After delta_count repeats, the segment goes back to it's initial value.  Must be >=1.
@param repeat_count The number of times the entire stimulus will repeat.  Must be >=1.
@param sample_period The sample period in seconds used when acquiring.  Be sure to manually include any
*/
DLLEXPORT unsigned long long CALL tecella_stimulus_sample_count_ex( TECELLA_HNDL h, TECELLA_STIMULUS_SEGMENT_EX *segments, int segment_count,
																																 int delta_count, int repeat_count, double sample_period );

/** Returns the number of samples to expect for a given stimulus, for only a single delta iteration.
@param h A handle to an initialized device.
@param segments A pointer to an array of segments that define the stimulus.
@param segment_count The number of segments to which segments points.
@param delta_iteration The step iteration of the stimulus used to calculate the sample count.
@param sample_period The sample period in seconds used when acquiring.
*/
DLLEXPORT unsigned int CALL tecella_stimulus_sample_count_partial( TECELLA_HNDL h, TECELLA_STIMULUS_SEGMENT *segments, int segment_count,
                                                                   int delta_iteration, double sample_period );

/** Returns the number of samples to expect for a given stimulus, for only a single delta iteration.
Note: This function has more functionality than the "non ex" version, but is more subject to change in future versions of the API.
@param h A handle to an initialized device.
@param segments A pointer to an array of segments that define the stimulus.
@param segment_count The number of segments to which segments points.
@param delta_iteration The step iteration of the stimulus used to calculate the sample count.
@param sample_period The sample period in seconds used when acquiring.
*/
DLLEXPORT unsigned int CALL tecella_stimulus_sample_count_partial_ex( TECELLA_HNDL h, TECELLA_STIMULUS_SEGMENT_EX *segments, int segment_count,
																																	 int delta_iteration, double sample_period );

/** Applies a voltage pulse of a specified duration.
@param h A handle to an initialized device.
@param duration The duration of the zap in seconds.  If duration is 0, zap will be held at the specified amplitude until the next call to this function.
@param amplitude The amplitude of the zap in Volts.
@param channels An array of channels to zap.
@param channel_count The number of channels in channel_array.
*/
DLLEXPORT TECELLA_ERRNUM CALL tecella_stimulus_zap(TECELLA_HNDL h, double duration, double amplitude, int *channels=0, int channel_count=0);

/** Steers the stimulus to the specified distination.
In most cases, the destination is a single channel.
Note that this is not supported by most hardware.  (As of 4/14, only Amadeus based amplifiers support this.)
Check the field supports_stimulus_steering in the hwprops to see if it is supported by your device.
@param h A handle to an initialized device.
@param stimulus_index The stimulus to steer.
@param destination_index In most cases, this is the channel to which we want to steer the stimulus.
@param enable If false, steers the stimulus to nothing.
**/
DLLEXPORT TECELLA_ERRNUM CALL
tecella_stimulus_steer(TECELLA_HNDL h, int stimulus_index, int destination_index, bool enable);

/*@}*/


/******************************************************************************
* Auto Compensation
******************************************************************************/

/**
 * @defgroup AutoCompensation Auto Compensation
 *
 * Various functions are provided by the API to automatically compensate for junction potential offsets, leakage current, and unwanted capacitive spikes.
 * Analog compensation is used when available.  Then, digital compensations can be used to compensate anything the analog compensations may have missed.
 *
 */
/*@{*/

/** This function adds an offset to the stimulus to compensate for junction potentials or other battery effects EXTERNAL to the amplifier.
This is accomplished by adjusting the JP register for each channel such that the measured current is as close to 0 Amps as possible for a 0 Volt stimulus.
Make sure tecella_auto_calibrate() has already been run to remove any internal interference.
All channels associated with the unused_stimulus_index will be compensated.
@note This function sets to zero any offsets added to the response when offset adjust mode is set to RESPONSE.
@param h A handle to an initialized device.
@param jp_delta Auto offset uses jp=0mV and jp=(jp_delta)mV to determine the best jp per channel. 0 indicates don't care.  This does not limit the final jp value, it only limits the jp values used to calculate the final jp value.
@param unused_stimulus_index A stimulus index that is not currently playing.  JP will be calculated for any channels associated with this stimulus.
*/
DLLEXPORT TECELLA_ERRNUM CALL
tecella_auto_offset(TECELLA_HNDL h, double jp_delta=0, int unused_stimulus_index=0);


/** Selects the offset adjust mode to use when tecella_auto_comp() is called.
Note: the resulting offset adjust after tecella_auto_comp() is only valid for the
	gain at which tecella_auto_comp() was run.
If you change the gain, you should turn off the offset adjust mode.
You should enable an offset adjust mode if you suspect JP will drift between experiments and you cannot use a 0mV as required by tecella_auto_offset().
This will allow you to adjust the offset using the same stimulus as requested of tecella_auto_comp().
@param h A handle to an initialized device.
@param channel The channel. TECELLA_ALLCHAN is allowed.
@param mode The offset mode to use for the given channel.
*/
DLLEXPORT TECELLA_ERRNUM CALL
tecella_auto_comp_offset_adjust_mode_set( TECELLA_HNDL h, int channel, TECELLA_OFFSET_ADJUST_MODE mode );

/** Gets the offset adjust mode to use when tecella_auto_comp is called
@param h A handle to an initialized device.
@param channel The channel. TECELLA_ALLCHAN is not allowed.
@param mode A return pointer for mode of the given channel.
*/
DLLEXPORT TECELLA_ERRNUM CALL
tecella_auto_comp_offset_adjust_mode_get( TECELLA_HNDL h, int channel, TECELLA_OFFSET_ADJUST_MODE *mode );

/** Sets values for leak, cfast, and all the cslows that will compensate for parasitics in the response.
All channels associated with the stimulus will be calibrated unless disabled using the function tecella_acquire_enable_channel().
If there's only 1 stimulus, this function cannot be used while acquiring.
If there is more than 1 stimulus, this function may be used while acquiring in continuous mode as long as the unused_stimulus_index is not acquiring.
If cfast or a cslow is used, artifact removal will automatically be disabled in order to get the best capacitance compensation.
Note: tecella_auto_comp() automatically disables artifact removal.
@param h A handle to an initialized device.
@param v_hold The holding voltage used by the auto comp algorithm.
@param t_hold Number of seconds to hold the holding voltage.
@param v_step The amplitude of the test pulse used by the auto compensation algorithm.
@param t_step Number of seconds to hold the pulse
@param use_leak If true, algorithm will compensate for leak if supported by the hardware.
@param use_digital_leak If true, auto comp digitally compensates for any leak not compensated by analog leak compensation.  Use tecella_chan_get_digital_leak() to retreive the resulting compensation.
@param use_cfast If true, algorithm will compensate using cfast if supported by the hardware. If false, cfast will remain untouched.
@param use_cslow_a If true, algorithm will compensate using cslowa if supported by the hardware. If false, cslowa will remain untouched.
@param use_cslow_b If true, algorithm will compensate using cslowb if supported by the hardware. If false, cslowb will remain untouched.
@param use_cslow_c If true, algorithm will compensate using cslowc if supported by the hardware. If false, cslowc will remain untouched.
@param use_cslow_d If true, algorithm will compensate using cslowd if supported by the hardware. If false, cslowd will remain untouched.
@param use_artifact If true, artifact removal will automatically be updated.  Not as accurate as running it separatly
@param under_comp_coefficient Indicates the how much you prefer under-compensation to over-compensation.  0 indicates no preference.  + indicates preference for under-compensation.  - indicates preference for over-compensation.  Magnitude indicates strengh of that preference.   If positive, the max error over:under should be close to 1:(1+under_comp_coefficient).  If negative, the max error under:over should be close to 1:(1-under_comp_coefficient).
@param acq_iterations Indicates how many vcmd pulses to average before calculating compensations.  Less iterations are faster, but more iterations are more accurate.
@param unused_stimulus_index An unused stimulus the algorithm can use for calibration.  Only associated channels are calibrated.
*/
DLLEXPORT TECELLA_ERRNUM CALL
tecella_auto_comp( TECELLA_HNDL h,
		   double v_hold=0, double t_hold=20e-3,
		   double v_step=10e-3, double t_step=20e-3,
		   bool use_leak=true,
		   bool use_digital_leak=true,
		   bool use_cfast=true,
		   bool use_cslow_a=true,
		   bool use_cslow_b=true,
		   bool use_cslow_c=true,
		   bool use_cslow_d=true,
		   bool use_artifact=true,
		   double under_comp_coefficient=0.0,
		   int acq_iterations=10,
		   int unused_stimulus_index=0 );


/** Lets the user indicate when artifact removal should start to linearly decay.
Decaying earlier results in a smoother transition, but may not compensate faster capacitances as well.
@param h A handle to an initialized device.
@param time_fraction Must be within the range [0,1].  Represents a fraction of t_step in tecella_auto_artifact_update() at which artifact removal should start decaying.
*/
DLLEXPORT TECELLA_ERRNUM CALL
tecella_auto_artifact_decay_start( TECELLA_HNDL h, double time_fraction);

/** Records artifacts that remain after capacitance compensation so that they can be removed automatically.
This function automatically enables artifact removal, so you must call tecella_auto_artifact_enable() with enable=false if you don't want the artifact removal to be applied immediately after calling this function.
Artifacts should be updated whenever there's a change in gain,compensations,or bessel filter.
Note: tecella_auto_comp() automatically disables artifact removal.
@param h A handle to an initialized device.
@param v_hold The holding voltage used by the auto comp algorithm.
@param t_hold Number of seconds to hold the holding voltage.  Tip: Use a combined value for t_hold+t_step that does not resonate with any environmental noise, such as 50Hz or 60Hz noise.
@param v_step The amplitude of the test pulse used by the auto compensation algorithm.
@param t_step Number of seconds to hold the pulse.  Also becomes the amount of time after an edge artifact removal will work in the future.  Tip: Use a combined value for t_hold+t_step that does not resonate with any environmental noise, such as 50Hz or 60Hz noise.
@param iterations How many vcmd pulses to average together when measuring the artifact.  Fewer iterations are faster, but more iterations reduces noise.
@param unused_stimulus_index An unused stimulus the algorithm can use for calibration.  Only associated channels are calibrated.
*/
DLLEXPORT TECELLA_ERRNUM CALL
tecella_auto_artifact_update( TECELLA_HNDL h,
                              double v_hold=0, double t_hold=19e-3,
                              double v_step=10e-3, double t_step=19e-3,
                              int iterations=10, int unused_stimulus_index=0);

/** Enables/disables the application artifact removal.  Does nothing if tecella_auto_artifact() hasn't been called.
Note: tecella_auto_comp() automatically disables artifact removal is any of the use_cfast or use_cslows are true and use_artifact is false.
@param h A handle to an initialized device.
@param enable Indicates if artifact removal should be turned on or off.
@param stimulus_index For which stimulus to turn off artifact removal.
*/
DLLEXPORT TECELLA_ERRNUM CALL
tecella_auto_artifact_enable( TECELLA_HNDL h, bool enable=true, int stimulus_index=0);

/** Returns the equivalent capacitance compensation of the artifact removal in Farads.
@param h A handle to an initialized device.
@param channel The channel you want the capacitance compensation of.
@param capacitance The equivalent capacitance compensation of artifact removal for the given channel.
*/
DLLEXPORT TECELLA_ERRNUM CALL
tecella_auto_artifact_get_capacitance( TECELLA_HNDL h, int channel, double *capacitance);

/** Gets the number of samples in the artifact for the given channel.
@param h A handle to an initialized device.
@param channel The channel you want the get the artifact removal size of.
@param size Upon return, will contain the size of the artifact data.
*/
DLLEXPORT TECELLA_ERRNUM CALL
tecella_auto_artifact_get_size( TECELLA_HNDL h, int channel, int *size );

/** Gets the current artifact data for a given channel.
The units for each sample in the artifact is Amps/Volts.  If you scale each sample by the step size of a voltage pulse, you will get the artifact in Amps that will be removed from the response.
Note: the artifact is always applied to the max sample rate available.
@param h A handle to an initialized device.
@param channel The channel you want the get the artifact removal of.
@param artifact A pointer to an array of doubles where the API can store the values for artifact removal.
@param max_size The maximum size of the artifact array.
@param actual_size Returns the number of elements stored into artifact.
*/
DLLEXPORT TECELLA_ERRNUM CALL
tecella_auto_artifact_get( TECELLA_HNDL h, int channel, double *artifact, int max_size, int *actual_size);

/** Sets the artifact to be removed for a given channel.
See tecella_auto_artifact_get() for a description of units used.
@param h A handle to an initialized device.
@param channel The channel you want set the artifact removal of.
@param artifact A pointer to an array of doubles that the API will use as the new artifact.
@param size The number of elements in artifact.
*/
DLLEXPORT TECELLA_ERRNUM CALL
tecella_auto_artifact_set( TECELLA_HNDL h, int channel, double *artifact, int size);

/** Automatically applies a frequency boost filter for the current gain and bessel settings.
Overwrites any filters set by tecella_sw_filter_set().
Not implemented yet...
@param h A handle to an initialized device.
@param lpf_width Short for low pass filter width.  Allows you to apply a low pass/decimation filter in parallel with the frequency boost.
@param stimulus A stimulus the function can use to acquire from.
*/
DLLEXPORT TECELLA_ERRNUM CALL
tecella_auto_frequency_boost_filter( TECELLA_HNDL h, int lpf_width, int stimulus=0 );

/*@}*/


/******************************************************************************
* Acquisition Filters
******************************************************************************/
/**
 * @defgroup Filtering DSP Filtering
 * TecellaAmp provides convenience functions for various downsampling filters
 * and user-defined FIR filters.
 */
/*@{*/

/** Enables/Disables filtering.
@param h A handle to an initialized device.
@param enable If true, filtering is enabled.  If false, filtering is disabled.
@param channel The channel on which to enable/disable filtering.
*/
DLLEXPORT TECELLA_ERRNUM CALL tecella_sw_filter_enable( TECELLA_HNDL h, bool enable, int channel=TECELLA_ALLCHAN );

/** Enables/Disables auto downsampling using a box filter.
Comes into play when the sample_period_multiplier in tecella_acquire_start is not 1.
The box filter is used in conjunction with the user defined filter.
@param h A handle to an initialized device.
@param enable If true, filtering is enabled.  If false, filtering is disabled.
@param channel The channel on which to enable/disable filtering.
*/
DLLEXPORT TECELLA_ERRNUM CALL tecella_sw_filter_auto_downsample( TECELLA_HNDL h, bool enable, int channel=TECELLA_ALLCHAN );

/** Sets a kernel to be convolved with incoming samples at the native sampling frequency.
Note: The kernel will be normalized before it is stored in the API to prevent unwanted scaling.
@param h A handle to an initialized device.
@param kernel An array of doubles that define the kernel.
@param kernel_size The number of elements in the kernel array.
@param channel Applies the filter to this channel.
*/
DLLEXPORT TECELLA_ERRNUM CALL tecella_sw_filter_set( TECELLA_HNDL h, double *kernel, int kernel_size, int channel=TECELLA_ALLCHAN );

/** Sets a simple nearest-neighbor averaging filter.
This acts as a low pass filter that doesn't have much ringing, but will not preserve peaks as well as a Lanczos filter.
@param h A handle to an initialized device.
@param width The number of samples to average together.
@param channel Applies the filter to this channel.
*/
DLLEXPORT TECELLA_ERRNUM CALL tecella_sw_filter_set_box( TECELLA_HNDL h, int width, int channel=TECELLA_ALLCHAN );

/** Sets a Lanczos filter kernel, which approximates the ideal low pass filter.
It preserves peaks well, however it may result in ringing near sharp edges.
For an explanation of Lanczos filters, see: http://en.wikipedia.org/wiki/Lanczos_resampling
@param h A handle to an initialized device.
@param width 1/width is the effective cutoff frequency of the Lanczos filter.  If downsampling, set width equal to the number of samples being decimated.  Using a width that is not a whole number will prevent the zeroes from falling exactly on a sample.
@param quality Must be 1 or greater. There are deminishing returns after 3.  Corresponds to the "a" coefficient usually used in texts when describing a Lanczos filter.
@param channel Applies the filter to this channel.
Note: The final size of the Lanczos filter will be width*quality.
*/
DLLEXPORT TECELLA_ERRNUM CALL tecella_sw_filter_set_lanczos( TECELLA_HNDL h, double width, int quality=3, int channel=TECELLA_ALLCHAN );

/*@}*/


/******************************************************************************
* Acquire
******************************************************************************/

/**
 * @defgroup Acquisition Acquisition
 * Acquisition can be started or stopped simply by calling tecella_acquire_start() and tecella_acquire_stop().
 *
 * The samples can be read in many different formats including raw, unscaled 16-bit integers (tecella_acquire_read_i()), 32-bit floats (tecella_acquire_read_f()), and 64-bit doubles (tecella_acquire_read_d()).  If reading the samples as 16-bit integers, you can scale to the proper units by using the scale returned by tecella_acquire_i2d_scale().
 *
 * If you do not need asynchronous control of multiple stimuli, you do not need to worry about the tecella_acquire_start_stimulus() and tecella_acquire_stop_stimulus() functions.
 *
 * Note: TecellaAmp allows you to use callbacks to get notifications of when samples are available, but it
 * is more straightforward to call tecella_acquire_read() in a blocking fashion if possible.
 *
 * Note: If you are receiving any software buffer overflow errors, you may want to increase the software buffer sizes via tecella_acquire_set_buffer_size().
 */
/*@{*/

/** Sets a callback function to be called whenever there is new data for any channel.
@param h A handle to an initialized device.
@param f The acquire callback function.
@param period The number of samples received in a channel before a notification is sent.  The number of samples notified may be less if any stimulus starts before the period has been reached or if acquisition has stopped for a particular channel.
*/
DLLEXPORT TECELLA_ERRNUM CALL tecella_acquire_set_callback(TECELLA_HNDL h, TECELLA_ACQUIRE_CB f, unsigned int period=1024);

/** Enables or disables acquisition for a channel.
All channels are enabled by default.
@param h A handle to an initialized device.
@param channel The channel to enable or disable.
@param enable If true, capture.  If false, don't.
*/
DLLEXPORT TECELLA_ERRNUM CALL tecella_acquire_enable_channel(TECELLA_HNDL h, int channel, bool enable);

/** Enables or disables auto-zero for a channel.
A window of initial samples is averaged to offset the entire acquisition, such that the window of samples average out to zero.
@param h A handle to an initialized device.
@param channel The channel to enable or disable.
@param enable If true, enable auto zero.
@param window_size The number of initial samples to average for the new zero level.
*/
DLLEXPORT TECELLA_ERRNUM CALL tecella_acquire_enable_auto_zero(TECELLA_HNDL h, int channel, bool enable, int window_size);

/** Pre-allocates an internal per-channel software queue for acquisition.
@param h A handle to an initialized device.
@param samples_per_chan Maximum number of samples per channel to allow in the queue.
*/
DLLEXPORT TECELLA_ERRNUM CALL tecella_acquire_set_buffer_size(TECELLA_HNDL h, unsigned int samples_per_chan);

/** Sets the trigger in mode.
@param h A handle to an initialized device.
@param active_high If true, trigger in occurs when going from low to high.  If false, trigger in occurs when going from high to low.
@param debounce_delay The trigger in must be high for at least this long before it is concidered true.  Units are in seconds.
*/
DLLEXPORT TECELLA_ERRNUM CALL
tecella_acquire_set_trigger_in_mode(TECELLA_HNDL h, bool active_high, double debounce_delay);

/** Sets up an acquisition and returns once the acquisition has begun.
When the function returns, an internal thread runs asynchronously that constantly pulls data from the device and pushes it into the internal queue.
@param h A handle to an initialized device.
@param sample_period_multiplier The actual sample period used will be sample_period_min times sample_peiriod_multiplier.
@param continuous If true, acquisition continues until tecella_acquire_stop() is called.  If false, acquisition continues for as long as the longest programmed stimulus or until tecella_acquire_stop() is called.
@param start_stimuli If true, all stimuli start playing at the start of acquisition and also capture continuously if continuous_stimuli is ture.  To use different options for different stimuli set both continuous_stimuli and start_stimuli to false and call tecella_acquire_start_stimulus() for each stimulus before calling tecella_acquire_start().
@param continuous_stimuli Valid only if continuous is true.  If true, all stimuli will capture continuously and also start playing if start_stimuli is true.  To use different options for different stimuli set both continuous_stimuli and start_stimuli to false and call tecella_acquire_start_stimulus() for each stimulus before calling tecella_acquire_start().
@param start_on_trigger If true, acquisition will not start until an external hardware trigger is detected.
*/
DLLEXPORT TECELLA_ERRNUM CALL tecella_acquire_start(TECELLA_HNDL h, int sample_period_multiplier, bool continuous=false, bool start_stimuli=true, bool continuous_stimuli=false, bool start_on_trigger=false );

/** Starts a stimulus and starts acquiring data for the associated channels that are also enabled.
tecella_acquire_start() must be called first, with continuous=true.
There are three modes available when calling tecella_acquire_start_stimulus():
Mode0) If start=false and continuous=false, tecella_acquire_start_stimulus does nothing.
Mode1) If start=false and continuous=true, you can acquire data continuously without starting the stimulus.
Mode2) If start=true and continuous=false, only the samples that are part of the stimulus will be acquired.
Mode3) If start=true and continuous=true, acquisition will start when the stimulus starts but then continue acquiring after the stimulus has ended, until tecella_acquire_stop_stimulus() is called.
@param h A handle to an initialized device.
@param stimulus_index The stimulus to start acquiring for.
@param start If true, the vcmd plays at the start of acquisition.
@param continuous If true, acquisition starts and continues until tecella_acquire_stop_stimulus() is called.  If false, acquisition only occurs while the stimlus is playing or until tecella_acquire_stop() is called.
@param sample_period_multiplier Multiplies the base sample period (specified in tecella_acquire_start()) by this number.
*/
DLLEXPORT TECELLA_ERRNUM CALL tecella_acquire_start_stimulus(TECELLA_HNDL h, int stimulus_index, bool start=true, bool continuous=false, int sample_period_multiplier=1);

/** Starts one or more stimuli and starts acquiring data for the associated channels that are also enabled.
tecella_acquire_start() must be called first, with continuous=true.
There are three modes available when calling tecella_acquire_start_stimuli():
Mode0) If start=false and continuous=false, tecella_acquire_start_stimuli does nothing.
Mode1) If start=false and continuous=true, you can acquire data continuously without starting the stimulus.
Mode2) If start=true and continuous=false, only the samples that are part of the stimulus will be acquired.
Mode3) If start=true and continuous=true, acquisition will start when the stimulus starts but then continue acquiring after the stimulus has ended, until tecella_acquire_stop_stimulus() is called.
@param h A handle to an initialized device.
@param stimulus_indexes A pointer to an array of stimulus indexes to start acquiring for.
@param stimulus_count The size of the array pointed to by stimulus_indexes.
@param start If true, the vcmd plays at the start of acquisition.
@param continuous If true, acquisition starts and continues until tecella_acquire_stop_stimulus() is called.  If false, acquisition only occurs while the stimlus is playing or until tecella_acquire_stop() is called.
@param sample_period_multiplier Multiplies the base sample period (specified in tecella_acquire_start()) by this number.
*/
DLLEXPORT TECELLA_ERRNUM CALL tecella_acquire_start_stimuli(TECELLA_HNDL h, int *stimulus_indexes, int stimulus_count, bool start=true, bool continuous=false, int sample_period_multiplier=1);

/** Stops a stimulus and stops acquiring data for the associated channels that are also enabled.
Valid only in asynchronous stimulus mode.
@param h A handle to an initialized device.
@param stimulus_index The stimulus to stop.
@param continuous If true, associated channels will continue acquiring even after stimulus has stopped.
*/
DLLEXPORT TECELLA_ERRNUM CALL tecella_acquire_stop_stimulus(TECELLA_HNDL h, int stimulus_index, bool continuous=false);

/** Stops the current acquistion and all stimuli.
Sends a message to the acquisition thread to stop and returns immediately.
@param h A handle to an initialized device.
*/
DLLEXPORT TECELLA_ERRNUM CALL tecella_acquire_stop(TECELLA_HNDL h);

/** Gets the current number of samples in the queue for the given channel.
@param h A handle to an initialized device.
@param chan The specified channel.  If TECELLA_ALLCHAN is specified,
this function returns the minimum samples available across all channels.
@param samples_available The number of samples available are returned in this variable.
*/
DLLEXPORT TECELLA_ERRNUM CALL tecella_acquire_samples_available(TECELLA_HNDL h, int chan, unsigned int *samples_available);

/** Reads samples from the queue as double-precision floats whose units are in Amps.
Once the requested data has been returned, it no longer resides in the queue and cannot be retrieved again.
All samples returned by a single call are continuous.
A call to this function will block until the number of requested_samples are available or until acqusition is complete.
To ensure this function is a non-blocking request use the number of samples returned by tecella_acquire_samples_available().
To recover from any acquisition error, call tecella_acquire_stop() and tecella_acquire_start() again.  It is not necessary to re-initialize the entire hardware.
@param h A handle to an initialized device.
@param chan The specified channel.  TECELLA_ALLCHAN cannot be used with this function.
@param requested_samples The number of samples the user would like to have copied to data.
@param data A pointer to an array of doubles, at least of size requested_samples.
@param actual_samples Used to return how many samples were actually acquired, in the case acquisition is complete.
@param first_sample_timestamp Timestamp of the first sample.  The timestamp increments by 1 for each sample period after the last call to tecella_acquire_start().  (To be implemented.)
@param last_sample_flag Indicates breaks in acquisition (samples after the last sample returned will not be captured). To be implemented.
@return TECELLA_ERR_OK If the read completed successfully.
@return TECELLA_ERR_SW_BUFFER_OVERFLOW If the software buffers have been filled.
@return TECELLA_ERR_HW_BUFFER_OVERFLOW If the hardware buffers have overflowed.
@return TECELLA_ERR_ACQ_CRC_FAILED If the data stream was corrupted. (Not implemented yet)
*/
DLLEXPORT TECELLA_ERRNUM CALL tecella_acquire_read_d(TECELLA_HNDL h, int chan, int requested_samples, double *data, unsigned int *actual_samples, unsigned long long *first_sample_timestamp, bool *last_sample_flag);

/** Reads samples from the queue as single-precision floats whose units are in Amps.
Same as tecella_acquire_read_d, but for single-precision floats.
*/
DLLEXPORT TECELLA_ERRNUM CALL tecella_acquire_read_f(TECELLA_HNDL h, int chan, int requested_samples, float *data, unsigned int *actual_samples, unsigned long long *first_sample_timestamp, bool *last_sample_flag);

/** Reads samples from the queue as 16 bit integers whose units can be retrieved using tecella_acquire_i2d_scale().
Once the requested data has been returned, it no longer resides in the queue and cannot be retrieved again.
A call to this function will block until the number of requested_samples are available or until acqusition is complete.
To ensure this function is a non-blocking request use the number of samples returned by tecella_acquire_samples_available().
To recover from any acquisition error, call tecella_acquire_stop() and tecella_acquire_start() again.  It is not necessary to re-initialize the entire hardware.
@param h A handle to an initialized device.
@param chan The specified channel.  TECELLA_ALLCHAN cannot be used with this function.
@param requested_samples The number of samples the user would like to have copied to data.
@param data A pointer to an array of shorts, at least of size requested_samples.
@param actual_samples Used to return how many samples were actually acquired, in the case acquisition is complete.
@param first_sample_timestamp Timestamp of the first sample.  The timestamp increments by 1 for each sample period after the last call to tecella_acquire_start().  (To be implemented.)
@param last_sample_flag Indicates breaks in acquisition (samples after the last sample returned will not be captured). To be implemented.
@return TECELLA_ERR_OK If the read completed successfully.
@return TECELLA_ERR_SW_BUFFER_OVERFLOW If the software buffers have been filled.
@return TECELLA_ERR_HW_BUFFER_OVERFLOW If the hardware buffers have overflowed.
@return TECELLA_ERR_ACQ_CRC_FAILED If the data stream was corrupted. (Not implemented yet)
*/
DLLEXPORT TECELLA_ERRNUM CALL tecella_acquire_read_i(TECELLA_HNDL h, int chan, int requested_samples, short  *data, unsigned int *actual_samples, unsigned long long *first_sample_timestamp, bool *last_sample_flag);

/** Determines if clipping has been detected since the last time this function was called for a given channel.
If this function returns clipping_detected as true, subsequent calls to this function will return clipping_detected as false unless clipping has been detected again.
@param h A handle to an initialized device.
@param chan The specified channel.  TECELLA_ALLCHAN cannot be used with this function.
@param clipping_detected Returns true if clipping has been detected since the last time this function was called.
*/
DLLEXPORT TECELLA_ERRNUM CALL tecella_acquire_read_clip_detect(TECELLA_HNDL h, int chan, bool *clipping_detected);

/** Gets the current multiplier used to convert a 16 bit short sample to Amps.
@param h A handle to an initialized device.
@param chan The specified channel.  TECELLA_ALLCHAN cannot be used with this function.
@param scale The return argument for the Amp multiplier.
*/
DLLEXPORT TECELLA_ERRNUM CALL tecella_acquire_i2d_scale(TECELLA_HNDL h, int chan, double *scale);

/*@}*/


/*! @page BlockingFunctions List of Blocking vs Non-Blocking Functions

\section NonBlocking Non Blocking
No IO necessary
- tecella_debug()
- tecella_debug_default()
- tecella_enumerate_get()
- tecella_initialize_pair()
- tecella_user_config_get()
- tecella_user_config_set()
- tecella_get_lib_props()
- tecella_get_reg_props()
- tecella_get_gain_label()
- tecella_get_source_label()
- tecella_error_message()
- tecella_error_set_callback()
- tecella_diagnostics_get_pass()
- tecella_diagnostics_get_failure()
- tecella_bessel_value2freq()
- tecella_bessel_freq2value()
- tecella_stimulus_set_callback()
- tecella_stimulus_sample_count()
- tecella_stimulus_sample_count_partial()
- tecella_auto_calibrate_get()
- tecella_auto_calibrate_set()
- tecella_auto_calibrate_leak_enable()
- tecella_auto_artifact_decay_start()
- tecella_auto_artifact_enable()
- tecella_auto_artifact_get_capacitance()
- tecella_auto_artifact_get_size()
- tecella_auto_artifact_get()
- tecella_auto_artifact_set()
- tecella_acquire_set_callback()
- tecella_acquire_enable_channel()
- tecella_acquire_set_buffer_size()
- tecella_acquire_samples_available()
- tecella_acquire_i2d_scale()

\section NonBlockingQIO Non-Blocking + Queued IO
No immediate IO, but IO is queued in another thread.  Can be called in parallel threads without regard to other IO.
- tecella_chan_set_source()
- tecella_chan_get_source()
- tecella_chan_set_gain()
- tecella_chan_get_gain()
- tecella_chan_set_stimulus()
- tecella_chan_get_stimulus()
- tecella_chan_set()
- tecella_chan_get()
- tecella_chan_set_pct()
- tecella_chan_get_pct()
- tecella_chan_set_enable()
- tecella_chan_get_enable()
- tecella_chan_set_bessel()
- tecella_chan_get_bessel()
- tecella_stimulus_zap()
- tecella_acquire_start_stimulus()
- tecella_acquire_start_stimuli()
- tecella_acquire_stop_stimulus()

\section SemiBlocking Semi-Blocking
Requires a small amount of IO on the scale of ms.
- tecella_enumerate()
- tecella_get_hw_props()
- tecella_finalize()
- tecella_utility_dac_set()
- tecella_utility_trigger_out()
- tecella_utility_set_stimulus()
- tecella_stimulus_set_hold()
- tecella_stimulus_get()
- tecella_acquire_start()

\section SemiBlockingQIO Semi-Blocking + Queued IO
Some immediate IO on the scale of ms + some queued IO.
- tecella_stimulus_set()

\section Blocking Blocking
Rrequires IO on the scale of seconds to complete.  If calls to these functions overlap with each other or occur after tecella_acquire_start and before tecella_acquire_stop, they will fail.
- tecella_initialize()
- tecella_diagnostics_run()
- tecella_auto_scale()
- tecella_auto_calibrate()
- tecella_auto_offset()
- tecella_auto_comp()
- tecella_auto_artifact_update()

\section Blocking Blocking2
Waits for in-flight IO and acquisition threads to end.
- tecella_acquire_stop()

\section Depends Depends
Non-blocking if requested samples are ready, blocking otherwise:
- tecella_acquire_read_d()
- tecella_acquire_read_f()
- tecella_acquire_read_i()
*/

/*@}*/


#ifdef __cplusplus
}

#endif
#endif
