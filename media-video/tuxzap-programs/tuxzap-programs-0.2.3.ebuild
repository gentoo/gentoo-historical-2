# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/tuxzap-programs/tuxzap-programs-0.2.3.ebuild,v 1.2 2003/09/07 00:08:13 msterret Exp $

IUSE="gtk"

MY_P=${PN/-/_}-${PV}
S=${WORKDIR}/${MY_P}
DESCRIPTION="mpegtools package for manipulation of various MPEG file formats"
HOMEPAGE="http://www.metzlerbros.org/dvb/"
SRC_URI="mirror://gentoo/${MY_P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86"

DEPEND=">=sys-apps/sed-4
	>=media-tv/linuxtv-dvb-1.0.0_pre2
	>=media-libs/libdvb-0.2.1
	dev-libs/cdk
	gtk? ( =x11-libs/gtk+-1.2* )"


src_compile() {
    MYCONF='--with-dvb-path=/usr/lib'
    # not using X use var because gtk is needed too anyway
    use gtk || MYCONF=${MYCONF}' --without-x'
    econf ${MYCONF}

    # still assumes to be in the DVB dir
    sed -i \
		-e s%../../../libdvb%/usr/include/libdvb%g  \
		-e s%../../../include%/usr/include%g \
		${S}/src/Makefile

    emake || die 'compile failed'
}

src_install() {
    make DESTDIR=${D} install || die

    # docs
    dodoc ${S}/README ${S}/AUTHORS ${S}/NEWS ${S}/ChangeLog
}

