# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/elisp-common.eclass,v 1.49 2008/10/12 19:48:21 ulm Exp $
#
# Copyright 2002-2004 Matthew Kennedy <mkennedy@gentoo.org>
# Copyright 2003      Jeremy Maitin-Shepard <jbms@attbi.com>
# Copyright 2004-2005 Mamoru Komachi <usata@gentoo.org>
# Copyright 2007-2008 Christian Faulhammer <opfer@gentoo.org>
# Copyright 2007-2008 Ulrich Müller <ulm@gentoo.org>
#
# @ECLASS: elisp-common.eclass
# @MAINTAINER:
# Feel free to contact the Emacs team through <emacs@gentoo.org> if you have
# problems, suggestions or questions.
# @BLURB: Emacs-related installation utilities
# @DESCRIPTION:
#
# Usually you want to use this eclass for (optional) GNU Emacs support of
# your package.  This is NOT for XEmacs!
#
# Many of the steps here are sometimes done by the build system of your
# package (especially compilation), so this is mainly for standalone elisp
# files you gathered from somewhere else.
#
# When relying on the emacs USE flag, you need to add
#
#   	emacs? ( virtual/emacs )
#
# to your DEPEND/RDEPEND line and use the functions provided here to bring
# the files to the correct locations.
#
# .SS
# src_compile() usage:
#
# An elisp file is compiled by the elisp-compile() function defined here and
# simply takes the source files as arguments.  The case of interdependent
# elisp files is also supported, since the current directory is added to the
# load-path which makes sure that all files are loadable.
#
#   	elisp-compile *.el || die "elisp-compile failed"
#
# Formerly, function elisp-comp() was used for compilation of interdependent
# elisp files.  This usage is considered as obsolete.
#
# Function elisp-make-autoload-file() can be used to generate a file with
# autoload definitions for the lisp functions.  It takes the output file name
# (default: "${PN}-autoloads.el") and a list of directories (default: working
# directory) as its arguments.  Use of this function requires that the elisp
# source files contain magic ";;;###autoload" comments.  See the Emacs Lisp
# Reference Manual (node "Autoload") for a detailed explanation.
#
# .SS
# src_install() usage:
#
# The resulting compiled files (.elc) should be put in a subdirectory of
# /usr/share/emacs/site-lisp/ which is named after the first argument
# of elisp-install().  The following parameters are the files to be put in
# that directory.  Usually the subdirectory should be ${PN}, you can choose
# something else, but remember to tell elisp-site-file-install() (see below)
# the change, as it defaults to ${PN}.
#
#   	elisp-install ${PN} *.el *.elc || die "elisp-install failed"
#
# To let the Emacs support be activated by Emacs on startup, you need
# to provide a site file (shipped in ${FILESDIR}) which contains the startup
# code (have a look in the documentation of your software).  Normally this
# would look like this:
#
#   	;;; csv-mode site-lisp configuration
#
#   	(add-to-list 'load-path "@SITELISP@")
#   	(add-to-list 'auto-mode-alist '("\\.csv\\'" . csv-mode))
#   	(autoload 'csv-mode "csv-mode" "Major mode for csv files." t)
#
# If your Emacs support files are installed in a subdirectory of
# /usr/share/emacs/site-lisp/ (which is recommended), you need to extend
# Emacs' load-path as shown in the first non-comment.
# The elisp-site-file-install() function of this eclass will replace
# "@SITELISP@" by the actual path.
#
# The next line tells Emacs to load the mode opening a file ending with
# ".csv" and load functions depending on the context and needed features.
# Be careful though.  Commands as "load-library" or "require" bloat the
# editor as they are loaded on every startup.  When having a lot of Emacs
# support files, users may be annoyed by the start-up time.  Also avoid
# keybindings as they might interfere with the user's settings.  Give a hint
# in pkg_postinst(), which should be enough.
#
# The naming scheme for this site file is "[0-9][0-9]*-gentoo.el", where the
# two digits at the beginning define the loading order.  So if you depend on
# another Emacs package, your site file's number must be higher!
#
# Best practice is to define a SITEFILE variable in the global scope of your
# ebuild (right after DEPEND e.g.):
#
#   	SITEFILE=50${PN}-gentoo.el
#
# Which is then installed by
#
#   	elisp-site-file-install "${FILESDIR}/${SITEFILE}" || die
#
# in src_install().  If your subdirectory is not named ${PN}, give the
# differing name as second argument.
#
# .SS
# pkg_postinst() / pkg_postrm() usage:
#
# After that you need to recreate the start-up file of Emacs after emerging
# and unmerging by using
#
#   	pkg_postinst() {
#   		elisp-site-regen
#   	}
#
#   	pkg_postrm() {
#   		elisp-site-regen
#   	}
#
# When having optional Emacs support, you should prepend "use emacs &&" to
# above calls of elisp-site-regen().  Don't use "has_version virtual/emacs"!
# When unmerging the state of the emacs USE flag is taken from the package
# database and not from the environment, so it is no problem when you unset
# USE=emacs between merge and unmerge of a package.
#
# .SS
# Miscellaneous functions:
#
# elisp-emacs-version() outputs the version of the currently active Emacs.

# @ECLASS-VARIABLE: SITELISP
# @DESCRIPTION:
# Directory where packages install Emacs Lisp files.
SITELISP=/usr/share/emacs/site-lisp

# @ECLASS-VARIABLE: SITEETC
# @DESCRIPTION:
# Directory where packages install miscellaneous (not Lisp) files.
SITEETC=/usr/share/emacs/etc

# @ECLASS-VARIABLE: SITEFILE
# @DESCRIPTION:
# Name of package's site-init file.
SITEFILE=50${PN}-gentoo.el

# @ECLASS-VARIABLE: EMACS
# @DESCRIPTION:
# Path of Emacs executable.
EMACS=/usr/bin/emacs

# @ECLASS-VARIABLE: EMACSFLAGS
# @DESCRIPTION:
# Flags for executing Emacs in batch mode.
# These work for Emacs versions 18-23, so don't change them.
EMACSFLAGS="-batch -q --no-site-file"

# @ECLASS-VARIABLE: BYTECOMPFLAGS
# @DESCRIPTION:
# Emacs flags used for byte-compilation in elisp-compile().
BYTECOMPFLAGS="-L ."

# @FUNCTION: elisp-compile
# @USAGE: <list of elisp files>
# @DESCRIPTION:
# Byte-compile Emacs Lisp files.
#
# This function uses GNU Emacs to byte-compile all ".el" specified by its
# arguments.  The resulting byte-code (".elc") files are placed in the same
# directory as their corresponding source file.
#
# The current directory is added to the load-path.  This will ensure that
# interdependent Emacs Lisp files are visible between themselves, in case
# they require or load one another.

elisp-compile() {
	ebegin "Compiling GNU Emacs Elisp files"
	${EMACS} ${EMACSFLAGS} ${BYTECOMPFLAGS} -f batch-byte-compile "$@"
	eend $? "elisp-compile: batch-byte-compile failed"
}

# #FUNCTION: elisp-comp
# #USAGE: <list of elisp files>
# #DESCRIPTION:
# Byte-compile interdependent Emacs Lisp files.
# THIS FUNCTION IS DEPRECATED.
#
# This function byte-compiles all ".el" files which are part of its
# arguments, using GNU Emacs, and puts the resulting ".elc" files into the
# current directory, so disregarding the original directories used in ".el"
# arguments.
#
# This function manages in such a way that all Emacs Lisp files to be
# compiled are made visible between themselves, in the event they require or
# load one another.

elisp-comp() {
	# Copyright 1995 Free Software Foundation, Inc.
	# François Pinard <pinard@iro.umontreal.ca>, 1995.
	# Originally taken from GNU autotools.

	ewarn "Function elisp-comp is deprecated and may be removed in future."
	ewarn "Please use function elisp-compile instead, or report a bug about"
	ewarn "${CATEGORY}/${PF} at <http://bugs.gentoo.org/>."
	echo

	[ $# -gt 0 ] || return 1

	ebegin "Compiling GNU Emacs Elisp files"

	local tempdir=elc.$$
	mkdir ${tempdir}
	cp "$@" ${tempdir}
	pushd ${tempdir}

	echo "(add-to-list 'load-path \"../\")" > script
	${EMACS} ${EMACSFLAGS} -l script -f batch-byte-compile *.el
	local ret=$?
	mv *.elc ..

	popd
	rm -fr ${tempdir}

	eend ${ret} "elisp-comp: batch-byte-compile failed"
}

# @FUNCTION: elisp-emacs-version
# @DESCRIPTION:
# Output version of currently active Emacs.

elisp-emacs-version() {
	# The following will work for at least versions 18-23.
	echo "(princ emacs-version)" >"${T}"/emacs-version.el
	${EMACS} ${EMACSFLAGS} -l "${T}"/emacs-version.el
	rm -f "${T}"/emacs-version.el
}

# @FUNCTION: elisp-make-autoload-file
# @USAGE: [output file] [list of directories]
# @DESCRIPTION:
# Generate a file with autoload definitions for the lisp functions.

elisp-make-autoload-file() {
	local f="${1:-${PN}-autoloads.el}"
	shift
	ebegin "Generating autoload file for GNU Emacs"

	sed 's/^FF/\f/' >"${f}" <<-EOF
	;;; ${f##*/} --- autoloads for ${P}

	;;; Commentary:
	;; Automatically generated by elisp-common.eclass
	;; DO NOT EDIT THIS FILE

	;;; Code:
	FF
	;; Local Variables:
	;; version-control: never
	;; no-byte-compile: t
	;; no-update-autoloads: t
	;; End:
	;;; ${f##*/} ends here
	EOF

	${EMACS} ${EMACSFLAGS} \
		--eval "(setq make-backup-files nil)" \
		--eval "(setq generated-autoload-file (expand-file-name \"${f}\"))" \
		-f batch-update-autoloads "${@-.}"

	eend $? "elisp-make-autoload-file: batch-update-autoloads failed"
}

# @FUNCTION: elisp-install
# @USAGE: <subdirectory> <list of files>
# @DESCRIPTION:
# Install files in SITELISP directory.

elisp-install() {
	local subdir="$1"
	shift
	ebegin "Installing Elisp files for GNU Emacs support"
	( # subshell to avoid pollution of calling environment
		insinto "${SITELISP}/${subdir}"
		doins "$@"
	)
	eend $? "elisp-install: doins failed"
}

# @FUNCTION: elisp-site-file-install
# @USAGE: <site-init file> [subdirectory]
# @DESCRIPTION:
# Install Emacs site-init file in SITELISP directory.

elisp-site-file-install() {
	local sf="${T}/${1##*/}" my_pn="${2:-${PN}}" ret
	ebegin "Installing site initialisation file for GNU Emacs"
	cp "$1" "${sf}"
	sed -i -e "s:@SITELISP@:${SITELISP}/${my_pn}:g" \
		-e "s:@SITEETC@:${SITEETC}/${my_pn}:g" "${sf}"
	( # subshell to avoid pollution of calling environment
		insinto "${SITELISP}/site-gentoo.d"
		doins "${sf}"
	)
	ret=$?
	rm -f "${sf}"
	eend ${ret} "elisp-site-file-install: doins failed"
}

# @FUNCTION: elisp-site-regen
# @DESCRIPTION:
# Regenerate the site-gentoo.el file, based on packages' site initialisation
# files in the /usr/share/emacs/site-lisp/site-gentoo.d/ directory.
#
# Note: Before December 2007, site initialisation files were installed in
# /usr/share/emacs/site-lisp/.  For backwards compatibility, this location is
# still supported when generating site-gentoo.el.

elisp-site-regen() {
	local i sf line firstrun obsolete
	local -a sflist
	# Work around Paludis borkage: variable T is empty in pkg_postrm
	local tmpdir=${T:-$(mktemp -d)}

	if [ ! -d "${ROOT}${SITELISP}" ]; then
		eerror "elisp-site-regen: Directory ${SITELISP} does not exist"
		return 1
	fi

	[ -e "${ROOT}${SITELISP}"/site-gentoo.el ] || firstrun=t

	if [ "${firstrun}" ] && [ ! -e "${ROOT}${SITELISP}"/site-start.el ]; then
		einfo "Creating default ${SITELISP}/site-start.el ..."
		cat <<-EOF >"${tmpdir}"/site-start.el
		;;; site-start.el

		;;; Commentary:
		;; This default site startup file is installed by elisp-common.eclass.
		;; You may replace this file by your own site initialisation, or even
		;; remove it completely; it will not be recreated.

		;;; Code:
		;; Load site initialisation for Gentoo-installed packages.
		(require 'site-gentoo)

		;;; site-start.el ends here
		EOF
	fi

	einfon "Regenerating ${SITELISP}/site-gentoo.el ..."

	# remove any auxiliary file (from previous run)
	rm -f "${ROOT}${SITELISP}"/00site-gentoo.el

	# set nullglob option, there may be a directory without matching files
	local old_shopts=$(shopt -p nullglob)
	shopt -s nullglob

	for sf in "${ROOT}${SITELISP}"/[0-9][0-9]*-gentoo.el \
		"${ROOT}${SITELISP}"/site-gentoo.d/[0-9][0-9]*.el
	do
		[ -r "${sf}" ] || continue
		# sort files by their basename. straight insertion sort.
		for ((i=${#sflist[@]}; i>0; i--)); do
			[[ ${sf##*/} < ${sflist[i-1]##*/} ]] || break
			sflist[i]=${sflist[i-1]}
		done
		sflist[i]=${sf}
		# set a flag if there are obsolete files
		[ "${sf%/*}" = "${ROOT}${SITELISP}" ] && obsolete=t
	done

	eval "${old_shopts}"

	cat <<-EOF >"${tmpdir}"/site-gentoo.el
	;;; site-gentoo.el --- site initialisation for Gentoo-installed packages

	;;; Commentary:
	;; Automatically generated by elisp-common.eclass
	;; DO NOT EDIT THIS FILE

	;;; Code:
	EOF
	cat "${sflist[@]}" </dev/null >>"${tmpdir}"/site-gentoo.el
	cat <<-EOF >>"${tmpdir}"/site-gentoo.el

	(provide 'site-gentoo)

	;; Local Variables:
	;; no-byte-compile: t
	;; End:
	;;; site-gentoo.el ends here
	EOF

	if cmp -s "${ROOT}${SITELISP}"/site-gentoo.el "${tmpdir}"/site-gentoo.el
	then
		# This prevents outputting unnecessary text when there
		# was actually no change.
		# A case is a remerge where we have doubled output.
		echo " no changes."
	else
		mv "${tmpdir}"/site-gentoo.el "${ROOT}${SITELISP}"/site-gentoo.el
		[ -f "${tmpdir}"/site-start.el ] \
			&& [ ! -e "${ROOT}${SITELISP}"/site-start.el ] \
			&& mv "${tmpdir}"/site-start.el "${ROOT}${SITELISP}"/site-start.el
		echo
		einfo "... ${#sflist[@]} site initialisation file(s) included."
	fi

	if [ "${firstrun}" ]; then
		echo
		while read line; do einfo "${line:- }"; done <<-EOF
		All site initialisation for Gentoo-installed packages is added to
		/usr/share/emacs/site-lisp/site-gentoo.el; site-start.el is not
		managed by Gentoo. You are responsible for all maintenance of
		site-start.el if there is such a file.

		In order for this site initialisation to be loaded for all users
		automatically, you can add a line like this:

		(require 'site-gentoo)

		to /usr/share/emacs/site-lisp/site-start.el. Alternatively, that line
		can be added by individual users to their initialisation files, or,
		for greater flexibility, users can load individual package-specific
		initialisation files from /usr/share/emacs/site-lisp/site-gentoo.d/.
		EOF
		echo
	fi

	if [ "${obsolete}" ]; then
		echo
		while read line; do ewarn "${line}"; done <<-EOF
		Site-initialisation files of Emacs packages are now installed in
		/usr/share/emacs/site-lisp/site-gentoo.d/. We strongly recommend
		that you use app-admin/emacs-updater to rebuild the installed
		Emacs packages.
		EOF

		# Kludge for backwards compatibility: During pkg_postrm, old versions
		# of this eclass (saved in the VDB) won't find packages' site-init
		# files in the new location. So we copy them to an auxiliary file
		# that is visible to old eclass versions.
		for sf in "${sflist[@]}"; do
			[ "${sf%/*}" = "${ROOT}${SITELISP}/site-gentoo.d" ] \
				&& cat "${sf}" >>"${ROOT}${SITELISP}"/00site-gentoo.el
		done
	fi

	# cleanup
	rm -f "${tmpdir}"/site-{gentoo,start}.el

	return 0
}
