# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/enlightenment.eclass,v 1.26 2004/10/21 19:59:40 vapier Exp $
#
# Author: vapier@gentoo.org

ECLASS=enlightenment
INHERITED="$INHERITED $ECLASS"

EXPORT_FUNCTIONS pkg_setup src_unpack src_compile src_install pkg_postinst

ECVS_STATE="release"
if [ "${PV/9999}" != "${PV}" ] ; then
	ECVS_MODULE="${ECVS_MODULE:-${PN}}"
	ECVS_SERVER="cvs.sourceforge.net:/cvsroot/enlightenment"
	ECVS_STATE="live"
	inherit cvs
elif [ "${PV/.200?????/}" != "${PV}" ] ; then
	ECVS_STATE="snap"
fi

DESCRIPTION="A DR17 production"
HOMEPAGE="http://www.enlightenment.org/"
case ${ECVS_STATE} in
	release) SRC_URI="mirror://sourceforge/enlightenment/${P}.tar.gz";;
	snap)    SRC_URI="mirror://gentoo/${P}.tar.bz2";;
	live)    SRC_URI="";;
esac

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc ~alpha ~hppa ~amd64 ~ia64"
IUSE="nls doc"

DEPEND="doc? ( app-doc/doxygen )
	>=sys-devel/autoconf-2.58-r1"
RDEPEND="nls? ( sys-devel/gettext )"

case ${ECVS_STATE} in
	release)   S=${WORKDIR}/${P};;
	snap|live) S=${WORKDIR}/${PN};;
esac

enlightenment_warning_msg() {
	if [ "${PV/200}" != "${PV}" ] ; then
		ewarn "Please do not contact the E team about bugs in Gentoo."
		ewarn "Only contact vapier@gentoo.org via e-mail or bugzilla."
		ewarn "Remember, this stuff is CVS only code so dont cry when"
		ewarn "I break you :)."
	fi
}

enlightenment_die() {
	enlightenment_warning_msg
	die "$@"$'\n'"!!! SEND BUG REPORTS TO vapier@gentoo.org NOT THE E TEAM"
}

enlightenment_pkg_setup() {
	enlightenment_warning_msg
}

# the stupid gettextize script prevents non-interactive mode, so we hax it
gettext_modify() {
	use nls || return 0
	cp `which gettextize` ${T} || die "could not copy gettextize"
	cp ${T}/gettextize ${T}/gettextize.old
	sed -e 's:read dummy < /dev/tty::' ${T}/gettextize.old > ${T}/gettextize
}

enlightenment_src_unpack() {
	[ "${ECVS_STATE}" != "live" ] && unpack ${A}
	gettext_modify
}

enlightenment_src_compile() {
	if [ "${ECVS_STATE}" != "release" ] ; then
		[ ! -z "${EHACKAUTOGEN}" ] && sed -i 's:.*configure.*::' autogen.sh
		export WANT_AUTOMAKE="${EAUTOMAKE:-1.8}"
		env \
			PATH="${T}:${PATH}" \
			NOCONFIGURE=yes \
			USER=blah \
			./autogen.sh \
			|| enlightenment_die "autogen failed"
		if [ ! -z "${EHACKLIBLTDL}" ] ; then
			cd libltdl
			autoconf || enlightenment_die "autogen in libltdl failed"
			cd ..
		fi
	fi
	econf ${MY_ECONF} || enlightenment_die "econf failed"
	emake || enlightenment_die "emake failed"
	use doc && [ -x ./gendoc ] && { ./gendoc || enlightenment_die "gendoc failed" ; }
}

enlightenment_src_install() {
	make install DESTDIR=${D} || enlightenment_die
	find ${D} -name CVS -type d -exec rm -rf '{}' \; 2>/dev/null
	dodoc AUTHORS ChangeLog NEWS README TODO ${EDOCS}
	use doc && [ -d doc ] && dohtml -r doc/*
}

enlightenment_pkg_postinst() {
	enlightenment_warning_msg
}
