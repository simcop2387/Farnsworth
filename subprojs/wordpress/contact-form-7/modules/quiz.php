<?php
/**
** A base module for [quiz]
**/

/* Shortcode handler */

wpef7_add_shortcode( 'quiz', 'wpef7_quiz_shortcode_handler', true );

function wpef7_quiz_shortcode_handler( $tag ) {
	global $wpef7_contact_form;

	if ( ! is_array( $tag ) )
		return '';

	$type = $tag['type'];
	$name = $tag['name'];
	$options = (array) $tag['options'];
	$pipes = $tag['pipes'];

	if ( empty( $name ) )
		return '';

	$atts = '';
	$id_att = '';
	$class_att = '';
	$size_att = '';
	$maxlength_att = '';
	$tabindex_att = '';

	$class_att .= ' wpef7-quiz';

	foreach ( $options as $option ) {
		if ( preg_match( '%^id:([-0-9a-zA-Z_]+)$%', $option, $matches ) ) {
			$id_att = $matches[1];

		} elseif ( preg_match( '%^class:([-0-9a-zA-Z_]+)$%', $option, $matches ) ) {
			$class_att .= ' ' . $matches[1];

		} elseif ( preg_match( '%^([0-9]*)[/x]([0-9]*)$%', $option, $matches ) ) {
			$size_att = (int) $matches[1];
			$maxlength_att = (int) $matches[2];

		} elseif ( preg_match( '%^tabindex:(\d+)$%', $option, $matches ) ) {
			$tabindex_att = (int) $matches[1];

		}
	}

	if ( $id_att )
		$atts .= ' id="' . trim( $id_att ) . '"';

	if ( $class_att )
		$atts .= ' class="' . trim( $class_att ) . '"';

	if ( $size_att )
		$atts .= ' size="' . $size_att . '"';
	else
		$atts .= ' size="40"'; // default size

	if ( $maxlength_att )
		$atts .= ' maxlength="' . $maxlength_att . '"';

	if ( '' !== $tabindex_att )
		$atts .= sprintf( ' tabindex="%d"', $tabindex_att );

	if ( is_a( $pipes, 'WPEF7_Pipes' ) && ! $pipes->zero() ) {
		$pipe = $pipes->random_pipe();
		$question = $pipe->before;
		$answer = $pipe->after;
	} else {
		// default quiz
		$question = '1+1=?';
		$answer = '2';
	}

	$answer = wpef7_canonicalize( $answer );

	$html = '<span class="wpef7-quiz-label">' . esc_html( $question ) . '</span>&nbsp;';
	$html .= '<input type="text" name="' . $name . '"' . $atts . ' />';
	$html .= '<input type="hidden" name="_wpef7_quiz_answer_' . $name . '" value="' . wp_hash( $answer, 'wpef7_quiz' ) . '" />';

	$validation_error = '';
	if ( is_a( $wpef7_contact_form, 'WPEF7_ContactForm' ) )
		$validation_error = $wpef7_contact_form->validation_error( $name );

	$html = '<span class="wpef7-form-control-wrap ' . $name . '">' . $html . $validation_error . '</span>';

	return $html;
}


/* Validation filter */

add_filter( 'wpef7_validate_quiz', 'wpef7_quiz_validation_filter', 10, 2 );

function wpef7_quiz_validation_filter( $result, $tag ) {
	global $wpef7_contact_form;

	$type = $tag['type'];
	$name = $tag['name'];

	$answer = wpef7_canonicalize( $_POST[$name] );
	$answer_hash = wp_hash( $answer, 'wpef7_quiz' );
	$expected_hash = $_POST['_wpef7_quiz_answer_' . $name];
	if ( $answer_hash != $expected_hash ) {
		$result['valid'] = false;
		$result['reason'][$name] = $wpef7_contact_form->message( 'quiz_answer_not_correct' );
	}

	return $result;
}


/* Ajax echo filter */

add_filter( 'wpef7_ajax_onload', 'wpef7_quiz_ajax_refill' );
add_filter( 'wpef7_ajax_json_echo', 'wpef7_quiz_ajax_refill' );

function wpef7_quiz_ajax_refill( $items ) {
	global $wpef7_contact_form;

	if ( ! is_a( $wpef7_contact_form, 'WPEF7_ContactForm' ) )
		return $items;

	if ( ! is_array( $items ) )
		return $items;

	$fes = $wpef7_contact_form->form_scan_shortcode(
		array( 'type' => 'quiz' ) );

	if ( empty( $fes ) )
		return $items;

	$refill = array();

	foreach ( $fes as $fe ) {
		$name = $fe['name'];
		$pipes = $fe['pipes'];

		if ( empty( $name ) )
			continue;

		if ( is_a( $pipes, 'WPEF7_Pipes' ) && ! $pipes->zero() ) {
			$pipe = $pipes->random_pipe();
			$question = $pipe->before;
			$answer = $pipe->after;
		} else {
			// default quiz
			$question = '1+1=?';
			$answer = '2';
		}

		$answer = wpef7_canonicalize( $answer );

		$refill[$name] = array( $question, wp_hash( $answer, 'wpef7_quiz' ) );
	}

	if ( ! empty( $refill ) )
		$items['quiz'] = $refill;

	return $items;
}


/* Messages */

add_filter( 'wpef7_messages', 'wpef7_quiz_messages' );

function wpef7_quiz_messages( $messages ) {
	return array_merge( $messages, array( 'quiz_answer_not_correct' => array(
		'description' => __( "Sender doesn't enter the correct answer to the quiz", 'wpef7' ),
		'default' => __( 'Your answer is not correct.', 'wpef7' )
	) ) );
}


/* Tag generator */

add_action( 'admin_init', 'wpef7_add_tag_generator_quiz', 40 );

function wpef7_add_tag_generator_quiz() {
	wpef7_add_tag_generator( 'quiz', __( 'Quiz', 'wpef7' ),
		'wpef7-tg-pane-quiz', 'wpef7_tg_pane_quiz' );
}

function wpef7_tg_pane_quiz( &$contact_form ) {
?>
<div id="wpef7-tg-pane-quiz" class="hidden">
<form action="">
<table>
<tr><td><?php echo esc_html( __( 'Name', 'wpef7' ) ); ?><br /><input type="text" name="name" class="tg-name oneline" /></td><td></td></tr>
</table>

<table>
<tr>
<td><code>id</code> (<?php echo esc_html( __( 'optional', 'wpef7' ) ); ?>)<br />
<input type="text" name="id" class="idvalue oneline option" /></td>

<td><code>class</code> (<?php echo esc_html( __( 'optional', 'wpef7' ) ); ?>)<br />
<input type="text" name="class" class="classvalue oneline option" /></td>
</tr>

<tr>
<td><code>size</code> (<?php echo esc_html( __( 'optional', 'wpef7' ) ); ?>)<br />
<input type="text" name="size" class="numeric oneline option" /></td>

<td><code>maxlength</code> (<?php echo esc_html( __( 'optional', 'wpef7' ) ); ?>)<br />
<input type="text" name="maxlength" class="numeric oneline option" /></td>
</tr>

<tr>
<td><?php echo esc_html( __( 'Quizzes', 'wpef7' ) ); ?><br />
<textarea name="values"></textarea><br />
<span style="font-size: smaller"><?php echo esc_html( __( "* quiz|answer (e.g. 1+1=?|2)", 'wpef7' ) ); ?></span>
</td>
</tr>
</table>

<div class="tg-tag"><?php echo esc_html( __( "Copy this code and paste it into the form left.", 'wpef7' ) ); ?><br /><input type="text" name="quiz" class="tag" readonly="readonly" onfocus="this.select()" /></div>
</form>
</div>
<?php
}

?>