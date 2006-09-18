# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/kde.eclass,v 1.178 2006/09/18 16:19:09 carlo Exp $
#
# Author Dan Armak <danarmak@gentoo.org>
#
# Revisions Caleb Tennis <caleb@gentoo.org>
# The kde eclass is inherited by all kde-* eclasses. Few ebuilds inherit
# straight from here.

inherit base eutils kde-functions flag-o-matic libtool
DESCRIPTION="Based on the $ECLASS eclass"
HOMEPAGE="http://www.kde.org/"
IUSE="debug xinerama"

if [[ ${ARTS_REQUIRED} != "yes" && ${ARTS_REQUIRED} != "never" && ${PN} != "arts" ]]; then
	IUSE="${IUSE} arts"
fi

if [[ ${CATEGORY} == "kde-base" ]]; then
	IUSE="${IUSE} kdeenablefinal"
	if [[ ${PV} == "3.5"* ]] && [[ ${PN} != "kdemultimedia" && ${KMNAME} != "kdemultimedia" ]]; then
		IUSE="${IUSE} kdehiddenvisibility"
	fi
fi

# Set USE_KEG_PACKAGING=1 before inheriting if the package use extragear-like
# packaging and then supports ${LANGS} and ${LANGS_DOC} variables.
if [[ -n ${USE_KEG_PACKAGING} && -n "${LANGS}${LANGS_DOC}" ]]; then
	for lang in ${LANGS} ${LANGS_DOC}; do
		IUSE="${IUSE} linguas_${lang}"
	done
fi

DEPEND=">=sys-devel/automake-1.7.0
	sys-devel/autoconf
	sys-devel/make
	dev-util/pkgconfig
	dev-lang/perl
	|| ( x11-proto/xf86vidmodeproto <virtual/x11-7 )
	xinerama? ( || ( x11-proto/xineramaproto <virtual/x11-7 ) )"

RDEPEND="xinerama? ( || ( x11-libs/libXinerama <virtual/x11-7 ) )"

if [[ ${ARTS_REQUIRED} == "yes" ]]; then
	DEPEND="${DEPEND} kde-base/arts"
	RDEPEND="${RDEPEND} kde-base/arts"
elif [[ ${ARTS_REQUIRED} != "never" && ${PN} != "arts" ]]; then
	DEPEND="${DEPEND} arts? ( kde-base/arts )"
	RDEPEND="${RDEPEND} arts? ( kde-base/arts )"
fi

# overridden in other places like kde-dist, kde-source and some individual ebuilds
SLOT="0"

kde_pkg_setup() {
	if [[ ${PN} != "arts" ]] && [[ ${PN} != "kdelibs" ]] ; then
		if [[ ${ARTS_REQUIRED} == 'yes' ]] || \
			( [[ ${ARTS_REQUIRED} != "never" ]] && use arts )  ; then
			if ! built_with_use kde-base/kdelibs arts ; then
				use arts && \
					eerror "You are trying to compile ${CATEGORY}/${PF} with the \"arts\" USE flag enabled." || \
					eerror "The package ${CATEGORY}/${PF} you're trying to merge requires aRTs."
				eerror "However, $(best_version kde-base/kdelibs) was compiled with arts flag disabled."
				eerror
				use arts && \
					eerror "You must either disable this use flag, or recompile" || \
					eerror "To build this package you have to recompile"
				eerror "$(best_version kde-base/kdelibs) with this arts use flag enabled."
				die "kdelibs missing arts"
			fi
		fi
	fi

	if [ "${PN}" = "kdelibs" ] ; then
		use doc && if ! built_with_use =x11-libs/qt-3* doc ; then
			eerror "Building kdelibs with the doc use flag requires qt to be built with the doc use flag."
			eerror "Please re-emerge qt-3 with this use flag enabled."
		fi
	fi

	# Let filter visibility flags that will *really* hurt your KDE
	# _experimental_ support for this is enabled by kdehiddenvisibility useflag
	filter-flags -fvisibility=hidden -fvisibility-inlines-hidden
}

kde_src_unpack() {
	debug-print-function $FUNCNAME $*

	[[ -z ${KDE_S} ]] && KDE_S="${S}"

	local PATCHDIR="${WORKDIR}/patches/"
	if [[ -z $* ]] ; then
		# Unpack first and deal with KDE patches after examing possible patch sets.
		# To be picked up, patches need to be named $PN-$PV-*{diff,patch} and be
		# placed in $PATCHDIR. Monolithic ebuilds will use the split ebuild patches.
		[[ -d ${KDE_S} ]] || base_src_unpack unpack
		if [[ -d "${PATCHDIR}" ]] ; then
			if is-parent-package ${CATEGORY}/${PN} ; then
				packages="$(get-child-packages ${CATEGORY}/${PN})"
				packages="${packages//${CATEGORY}\//} ${PN}"
			else
				packages="${PN}"
			fi
			for _p in ${packages} ; do
				PATCHES="${PATCHES} $(ls ${PATCHDIR}/${_p}-${PV}-*{diff,patch} 2>/dev/null)"
				if [[ -n "${KDEBASE}" ]] ; then
					PATCHES="${PATCHES} $(ls ${PATCHDIR}/${_p}-${SLOT}-*{diff,patch} 2>/dev/null)"
				fi
			done
		fi
		[[ -n ${PATCHES} ]] && base_src_unpack autopatch
	else
		# Call base_src_unpack, which has sections, to do unpacking and patching
		# step by step transparently as defined in the ebuild.
		base_src_unpack $*
	fi

	# if extragear-like packaging is enabled, set the translations and the
	# documentation depending on LINGUAS settings
	if [[ -n ${USE_KEG_PACKAGING} ]]; then
		if [[ -z ${LINGUAS} ]]; then
			einfo "You can drop some of the translations of the interface and"
			einfo "documentation by setting the \${LINGUAS} variable to the"
			einfo "languages you want installed."
			einfo
			einfo "Enabling all languages"
		else
			if [[ -n ${LANGS} ]]; then
				MAKE_PO=$(echo $(echo "${LINGUAS} ${LANGS}" | fmt -w 1 | sort | uniq -d))
				einfo "Enabling translations for: ${MAKE_PO}"
				sed -i -e "s:^SUBDIRS =.*:SUBDIRS = ${MAKE_PO}:" "${KDE_S}/po/Makefile.am" \
					|| die "sed for locale failed"
				rm -f "${KDE_S}/configure"
			fi

			if [[ -n ${LANGS_DOC} ]]; then
				MAKE_DOC=$(echo $(echo "${LINGUAS} ${LANGS_DOC}" | fmt -w 1 | sort | uniq -d))
				einfo "Enabling documentation for: ${MAKE_DOC}"
				sed -i -e "s:^SUBDIRS =.*:SUBDIRS = ${MAKE_DOC} ${PN}:" \
					"${KDE_S}/doc/Makefile.am" || die "sed for locale failed"
				rm -f "${KDE_S}/configure"
			fi
		fi
	fi

	# fix the 'languageChange undeclared' bug group: touch all .ui files, so that the
	# makefile regenerate any .cpp and .h files depending on them.
	cd "${KDE_S}"
	debug-print "$FUNCNAME: Searching for .ui files in $PWD"
	UIFILES="`find . -name '*.ui' -print`"
	debug-print "$FUNCNAME: .ui files found:"
	debug-print "$UIFILES"
	# done in two stages, because touch doens't have a silent/force mode
	if [ -n "$UIFILES" ]; then
		debug-print "$FUNCNAME: touching .ui files..."
		touch $UIFILES
	fi
}

kde_src_compile() {

	debug-print-function $FUNCNAME $*
	[ -z "$1" ] && kde_src_compile all

	[[ -z ${KDE_S} ]] && KDE_S="${S}"
	cd "${KDE_S}"

	export kde_widgetdir="$KDEDIR/$(get_libdir)/kde3/plugins/designer"

	# fix the sandbox errors "can't writ to .kde or .qt" problems.
	# this is a fake homedir that is writeable under the sandbox, so that the build process
	# can do anything it wants with it.
	REALHOME="$HOME"
	mkdir -p $T/fakehome/.kde
	mkdir -p $T/fakehome/.qt
	export HOME="$T/fakehome"
	addwrite "${QTDIR}/etc/settings"

	# Fix bug 96177: if KDEROOTHOME is defined, the ebuild accesses the real homedir via it, and not our exported $HOME
	unset KDEHOME
	unset KDEROOTHOME

	# things that should access the real homedir
	[ -d "$REALHOME/.ccache" ] && ln -sf "$REALHOME/.ccache" "$HOME/"
	[ -n "$UNSERMAKE" ] && addwrite "/usr/kde/unsermake"

	while [ "$1" ]; do

		case $1 in
			myconf)
				debug-print-section myconf
				myconf="$myconf --with-x --enable-mitshm $(use_with xinerama) --with-qt-dir=${QTDIR} --enable-mt --with-qt-libraries=${QTDIR}/$(get_libdir)"
				# calculate dependencies separately from compiling, enables ccache to work on kde compiles
				[[ -z "$UNSERMAKE" ]] && myconf="$myconf --disable-dependency-tracking"
				if use debug ; then
					myconf="$myconf --enable-debug=full --with-debug"
				else
					myconf="$myconf --disable-debug --without-debug"
				fi
				if hasq kdeenablefinal ${IUSE}; then
					myconf="$myconf $(use_enable kdeenablefinal final)"
				fi
				if [[ ${ARTS_REQUIRED} == "never" ]]; then
					myconf="$myconf --without-arts"
				elif [[ ${ARTS_REQUIRED} != 'yes' && ${PN} != "arts" ]]; then
					# This might break some external package until
					# ARTS_REQUIRED="yes" is set on them, KDE 3.2 is no more
					# supported anyway.
					myconf="$myconf $(use_with arts)"
				fi
				debug-print "$FUNCNAME: myconf: set to ${myconf}"
				;;
			configure)
				debug-print-section configure
				debug-print "$FUNCNAME::configure: myconf=$myconf"

				# This is needed to fix building with autoconf 2.60.
				# Many thanks to who preferred such a stupid check rather
				# than a working arithmetic comparison.
				if [[ -f admin/cvs.sh ]]; then
					sed -i -e '/case $AUTO\(CONF\|HEADER\)_VERSION in/,+1 s/2\.5/2.[56]/g' \
						admin/cvs.sh
				fi

				# For some reasons, autoconf 2.60 throws up lots of warnings when using
				# older versions of automake, so force automake 1.9 when using that
				if [[ $(autoconf --version) == autoconf*2.60* ]]; then
					einfo "Forcing automake 1.9 when using autoconf 2.60"
					export WANT_AUTOMAKE="1.9"
				fi

				# rebuild configure script, etc
				# This can happen with e.g. a cvs snapshot
				if [ ! -f "./configure" ] || [ -n "$UNSERMAKE" ]; then
					for x in Makefile.cvs admin/Makefile.common; do
						if [ -f "$x" ] && [ -z "$makefile" ]; then makefile="$x"; fi
					done
					if [ -f "$makefile" ]; then
						debug-print "$FUNCNAME: configure: generating configure script, running make -f $makefile"
						emake -j1 -f $makefile
					fi
					[ -f "./configure" ] || die "no configure script found, generation unsuccessful"
				fi

				export PATH="${KDEDIR}/bin:${PATH}"

				# configure doesn't need to know about the other KDEs installed.
				# in fact, if it does, it sometimes tries to use the wrong dcopidl, etc.
				# due to the messed up way configure searches for things
				export KDEDIRS="${PREFIX}:${KDEDIR}"

				# Visiblity stuff is broken. Just disable it when it's present.
				export kde_cv_prog_cxx_fvisibility_hidden=no

				if hasq kdehiddenvisibility ${IUSE} && use kdehiddenvisibility; then
					if [[ $(gcc-major-version)$(gcc-minor-version) -ge 41 ]]; then
						if [[ ${PN} != "kdelibs" && ${PN} != "arts" ]] && \
							! fgrep -q "#define __KDE_HAVE_GCC_VISIBILITY" "${KDEDIR}/include/kdemacros.h"; then

							eerror "You asked to enable hidden visibility, but your kdelibs was"
							eerror "built without its support. Please rebuild kdelibs with the"
							eerror "kdehiddenvisibility useflag enabled."
							die "kdelibs without hidden visibility"
						else
							unset kde_cv_prog_cxx_fvisibility_hidden
							myconf="$myconf $(use_enable kdehiddenvisibility gcc-hidden-visibility)"
						fi
					else
						eerror "You're trying to enable hidden visibility, but"
						eerror "you are using an old GCC version. Hidden visibility"
						eerror "can be enabled only with GCC 4.1 and later."
					fi
				fi

				# If we're in a kde-base ebuild, set the prefixed directories to
				# override the ones set by econf.
				if [[ -n ${PREFIX} && ${PREFIX} != "/usr" ]]; then
					myconf="${myconf} --prefix=${PREFIX}
						--mandir=${PREFIX}/share/man
						--infodir=${PREFIX}/share/info
						--datadir=${PREFIX}/share
						--sysconfdir=${PREFIX}/etc"
				fi

				# Use libsuffix to keep KDE happy, the --libdir parameter get
				# still honored.
				if [[ $(get_libdir) != "lib" ]] ; then
					myconf="${myconf} --enable-libsuffix=$(get_libdir | sed s/lib//)"
				fi

				# Sometimes it doesn't get the include and library paths right,
				# so hints them.
				if [[ -z ${PREFIX} || ${PREFIX} != ${KDEDIR} ]]; then
					myconf="${myconf} --with-extra-includes=${KDEDIR}/include
						--with-extra-libs=${KDEDIR}/$(get_libdir)"
				fi

				if grep "cope with newer libtools" "${KDE_S}/admin/ltconfig" &> /dev/null; then
					einfo "Removing the dummy ltconfig file."
					rm "${KDE_S}/admin/ltconfig"
				fi
				elibtoolize
				econf \
					${myconf} \
					|| die "died running ./configure, $FUNCNAME:configure"

				# Seems ./configure add -O2 by default but hppa don't want that but we need -ffunction-sections
				if [[ "${ARCH}" = "hppa" ]]
				then
					einfo Fixating Makefiles
					find ${KDE_S} -name Makefile -print0 | xargs -0 sed -i -e \
						's:-O2:-ffunction-sections:g'
				fi
				;;
			make)
				export PATH="${KDEDIR}/bin:${PATH}"
				debug-print-section make
				emake || die "died running emake, $FUNCNAME:make"
				;;
			all)
				debug-print-section all
				kde_src_compile myconf configure make
				;;
		esac

	shift
	done

}

kde_src_install() {

	debug-print-function $FUNCNAME $*
	[[ -z "$1" ]] && kde_src_install all

	[[ -z ${KDE_S} ]] && KDE_S="${S}"
	cd "${KDE_S}"

	while [[ "$1" ]]; do

		case $1 in
			make)
				debug-print-section make
				emake install DESTDIR=${D} destdir=${D} || die "died running make install, $FUNCNAME:make"
				;;
			dodoc)
				debug-print-section dodoc
				for doc in AUTHORS ChangeLog* README* NEWS TODO; do
					[ -s "$doc" ] && dodoc $doc
				done
				;;
			all)
				debug-print-section all
				kde_src_install make dodoc
				;;
		esac

	shift
	done

	if [[ -n ${KDEBASE} ]] && [[ "${PN}" != "arts" ]] ; then
		# work around bug #97196
		mv ${D}/usr/share/doc/* "${D}/${KDEDIR}/share/doc/"
	fi
}

# slot rebuild function, thanks to Carsten Lohrke in bug 98425.
slot_rebuild() {
	local VDB_PATH="$(portageq vdb_path)"
	local REBUILD_LIST=""
	local BROKEN_PKGS=""

	echo
	einfo "Scan for possible needed slot related rebuilds.\n"
	echo
	for i in ${*} ; do
		local temp="$(ls -1d ${VDB_PATH}/${i}*)"
		for j in ${temp} ; do
			if ! [[ -f ${j}/CONTENTS ]] ; then
				eerror "The package db entry for ${j/${VDB_PATH}\//} is broken."
				BROKEN_PKGS="${BROKEN_PKGS} ${j/${VDB_PATH}\//}"
				continue
			fi

			k="$(grep -o "/.*/lib.*\.la" ${j}/CONTENTS)"
			m=""
			for l in ${k} ; do [[ -e ${l} ]] && m="${m} ${l}"; done
			l="$(echo ${k} ${m} | fmt -w 1 | sort | uniq -u)"

			if [[ ${l} != "" ]] || [[ ${m} == "" ]] ; then
				eerror "Installation of ${j/${VDB_PATH}\//} is broken."
				BROKEN_PKGS="${BROKEN_PKGS} ${j/${VDB_PATH}\//}"
			else
				if [[ $(cat ${m}  | grep -co "${KDEDIR}") = 0 ]] ; then
					REBUILD_LIST="${REBUILD_LIST} =${j/${VDB_PATH}\//}"
				fi
			fi
		done
	done
	echo
	if [[ -n "${BROKEN_PKGS}" ]] ; then
		eerror "Anomalies were found. Please do \"emerge ${BROKEN_PKGS}\"."
		return 0
	fi


	if [[ -n "${REBUILD_LIST}" ]] ; then
		local temp=""
		cd ${VDB_PATH}
		for i in ${REBUILD_LIST} ; do
			i="$(echo ${i%-*} | cut -d= -f2)"
			temp="${temp} $(find .	-iname "DEPEND" -exec grep -H ${i} '{}' \; | cut -f2-3 -d/ | grep -v ${CATEGORY}/${PN})"
		done
		temp="$(echo ${temp} | fmt -w 1 | sort -u)"
		for i in ${temp} ; do
			REBUILD_LIST="${REBUILD_LIST} =${i}"
		done
	fi

	if [[ -n "${REBUILD_LIST}" ]] ; then
		einfo "Please run \"emerge --oneshot ${REBUILD_LIST}\" before continuing.\n"
	else
		einfo "Done :), continuing...\n"
		return 1
	fi
	echo
}

kde_pkg_postinst() {
	buildsycoca
}

kde_pkg_postrm() {
	buildsycoca
}

EXPORT_FUNCTIONS pkg_setup src_unpack src_compile src_install pkg_postinst pkg_postrm
