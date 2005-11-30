# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnustep-base/gnustep-back-xlib/gnustep-back-xlib-0.9.5_pre20050312.ebuild,v 1.1 2005/03/17 20:55:08 fafhrd Exp $

ECVS_CVS_COMMAND="cvs -q"
ECVS_SERVER="savannah.gnu.org:/cvsroot/gnustep"
ECVS_USER="anoncvs"
ECVS_AUTH="ext"
ECVS_MODULE="gnustep/core/back"
ECVS_CO_OPTS="-P -D ${PV/*_pre}"
ECVS_UP_OPTS="-dP -D ${PV/*_pre}"
ECVS_TOP_DIR="${DISTDIR}/cvs-src/savannah.gnu.org-gnustep"
inherit gnustep cvs

S=${WORKDIR}/${ECVS_MODULE}

DESCRIPTION="Default X11 back-end component for the GNUstep GUI Library."
HOMEPAGE="http://www.gnustep.org"

KEYWORDS="~x86 ~ppc ~sparc"
SLOT="0"
LICENSE="LGPL-2.1"

PROVIDE="virtual/gnustep-back"

IUSE="${IUSE} opengl xim doc"
DEPEND="${GNUSTEP_GUI_DEPEND}
	=gnustep-base/gnustep-gui-${PV}*
	virtual/xft
	opengl? ( virtual/opengl virtual/glu )"
RDEPEND="${DEPEND}
	${DOC_RDEPEND}"

egnustep_install_domain "System"

src_unpack() {
	cvs_src_unpack ${A}
	EPATCH_OPTS="-d ${S}" epatch ${FILESDIR}/font-make-fix.patch-${PV}
	cd ${S}
}

src_compile() {
	egnustep_env

	use opengl && myconf="--enable-glx"
	myconf="$myconf `use_enable xim`"
	myconf="$myconf --enable-server=x11"
	myconf="$myconf --enable-graphics=xlib --with-name=xlib"
	econf $myconf || die "configure failed"

	egnustep_make
}

