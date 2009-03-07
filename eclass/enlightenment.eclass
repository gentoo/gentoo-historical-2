# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/enlightenment.eclass,v 1.80 2009/03/07 22:28:16 vapier Exp $
#
# Author: vapier@gentoo.org

inherit eutils libtool

# E_STATE's:
#	release      [default]
#		KEYWORDS arch
#		SRC_URI  $P.tar.gz
#		S        $WORKDIR/$P
#
#	snap         $PV has .200##### datestamp or .### counter
#		KEYWORDS ~arch
#		SRC_URI  $P.tar.bz2
#		S        $WORKDIR/$P
#
#	live         $PV has a 9999 marker
#		KEYWORDS ""
#		SRC_URI  cvs/svn/etc... up
#		S        $WORKDIR/$E_S_APPEND
#
# Overrides:
#	KEYWORDS    EKEY_STATE
#	SRC_URI     EURI_STATE
#	S           EURI_STATE

#E_LIVE_DEFAULT_CVS="cvs.sourceforge.net:/cvsroot/enlightenment"
E_LIVE_SERVER_DEFAULT_CVS="anoncvs.enlightenment.org:/var/cvs/e"
E_LIVE_SERVER_DEFAULT_SVN="http://svn.enlightenment.org/svn/e/trunk"

E_STATE="release"
if [[ ${PV/9999} != ${PV} ]] ; then
	E_LIVE_SERVER=${E_LIVE_SERVER:-${E_LIVE_SERVER_DEFAULT_SVN}}
	E_STATE="live"
	WANT_AUTOTOOLS="yes"

	# force people to opt-in to legacy cvs
	if [[ -n ${ECVS_MODULE} ]] ; then
		ECVS_SERVER=${ECVS_SERVER:-${E_LIVE_SERVER_DEFAULT_CVS}}
		E_LIVE_SOURCE="cvs"
		E_S_APPEND=${ECVS_MODULE}
		inherit cvs
	else
		ESVN_URI_APPEND=${ESVN_URI_APPEND:-${PN}}
		ESVN_PROJECT="enlightenment/${ESVN_SUB_PROJECT}"
		ESVN_REPO_URI=${ESVN_SERVER:-${E_LIVE_SERVER_DEFAULT_SVN}}/${ESVN_SUB_PROJECT}/${ESVN_URI_APPEND}
		E_S_APPEND=${ESVN_URI_APPEND}
		E_LIVE_SOURCE="svn"
		inherit subversion
	fi
elif [[ -n ${E_SNAP_DATE} ]] ; then
	E_STATE="snap"
else
	E_STATE="release"
fi
if [[ ${WANT_AUTOTOOLS} == "yes" ]] ; then
	WANT_AUTOCONF=${E_WANT_AUTOCONF:-latest}
	WANT_AUTOMAKE=${E_WANT_AUTOMAKE:-latest}
	inherit autotools
fi

DESCRIPTION="A DR17 production"
HOMEPAGE="http://www.enlightenment.org/"
case ${EURI_STATE:-${E_STATE}} in
	release) SRC_URI="mirror://sourceforge/enlightenment/${P}.tar.gz";;
	snap)    SRC_URI="http://download.enlightenment.org/snapshots/${E_SNAP_DATE}/${P}.tar.bz2";;
	live)    SRC_URI="";;
esac

LICENSE="BSD"
SLOT="0"
case ${EKEY_STATE:-${E_STATE}} in
	release) KEYWORDS="alpha amd64 arm hppa ia64 mips ppc ppc64 sh sparc x86 ~x86-fbsd";;
	snap)    KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd";;
	live)    KEYWORDS="";;
esac
IUSE="nls doc"

DEPEND="doc? ( app-doc/doxygen )"
RDEPEND="nls? ( sys-devel/gettext )"

# gettext (via `autopoint`) needs to run cvs #245073
[[ ${E_STATE} == "live" ]] && DEPEND="${DEPEND} dev-util/cvs"

case ${EURI_STATE:-${E_STATE}} in
	release) S=${WORKDIR}/${P};;
	snap)    S=${WORKDIR}/${P};;
	live)    S=${WORKDIR}/${E_S_APPEND};;
esac

enlightenment_warning_msg() {
	if [[ -n ${E_LIVE_SERVER} ]] ; then
		einfo "Using user server for live sources: ${E_LIVE_SERVER}"
	fi
	if [[ ${E_STATE} == "snap" ]] ; then
		ewarn "Please do not contact the E team about bugs in Gentoo."
		ewarn "Only contact enlightenment@gentoo.org via e-mail or bugzilla."
		ewarn "Remember, this stuff is DEV only code so dont cry when"
		ewarn "I break you :)."
	elif [[ ${E_STATE} == "live" ]] ; then
		eerror "This is a LIVE SOURCES ebuild."
		eerror "That means there are NO promises it will work."
		eerror "If it fails to build, FIX THE CODE YOURSELF"
		eerror "before reporting any issues."
	fi
}

enlightenment_die() {
	enlightenment_warning_msg
	die "$@"$'\n'"!!! SEND BUG REPORTS TO enlightenment@gentoo.org NOT THE E TEAM"
}

enlightenment_pkg_setup() {
	: enlightenment_warning_msg
}

# the stupid gettextize script prevents non-interactive mode, so we hax it
gettext_modify() {
	use nls || return 0
	cp $(type -P gettextize) "${T}"/ || die "could not copy gettextize"
	sed -i \
		-e 's:read dummy < /dev/tty::' \
		"${T}"/gettextize
}

enlightenment_src_unpack() {
	if [[ ${E_STATE} == "live" ]] ; then
		case ${E_LIVE_SOURCE} in
			cvs) cvs_src_unpack;;
			svn) subversion_src_unpack;;
			*)   die "eek!";;
		esac
	else
		unpack ${A}
	fi
	gettext_modify
	[[ -s gendoc ]] && chmod a+rx gendoc
}

enlightenment_src_compile() {
	# gstreamer sucks, work around it doing stupid stuff
	export GST_REGISTRY="${S}/registry.xml"

	if [[ ! -e configure ]] ; then
		env \
			PATH="${T}:${PATH}" \
			NOCONFIGURE=yes \
			USER=blah \
			./autogen.sh \
			|| enlightenment_die "autogen failed"
		# symlinked files will cause sandbox violation
		local x
		for x in config.{guess,sub} ; do
			[[ ! -L ${x} ]] && continue
			rm -f ${x}
			touch ${x}
		done
	elif [[ ${WANT_AUTOTOOLS} == "yes" ]] ; then
		eautoreconf
	fi
	epunt_cxx
	elibtoolize
	econf ${MY_ECONF} || enlightenment_die "econf failed"
	emake || enlightenment_die "emake failed"
	use doc && [[ -x ./gendoc ]] && { ./gendoc || enlightenment_die "gendoc failed" ; }
}

enlightenment_src_install() {
	emake install DESTDIR="${D}" || enlightenment_die
	find "${D}" '(' -name CVS -o -name .svn -o -name .git ')' -type d -exec rm -rf '{}' \; 2>/dev/null
	for d in AUTHORS ChangeLog NEWS README TODO ${EDOCS}; do
		[[ -f ${d} ]] && dodoc ${d}
	done
	use doc && [[ -d doc ]] && dohtml -r doc/*
}

enlightenment_pkg_postinst() {
	: enlightenment_warning_msg
}

EXPORT_FUNCTIONS pkg_setup src_unpack src_compile src_install pkg_postinst
