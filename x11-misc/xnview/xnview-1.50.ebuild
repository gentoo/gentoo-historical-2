# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/xnview/xnview-1.50.ebuild,v 1.9 2004/05/07 20:39:27 tseng Exp $

inherit rpm

MY_PN=XnView-static
MY_P="${MY_PN}-${PV}"

DESCRIPTION="XnView image viewer/converter"
HOMEPAGE="http://www.xnview.com/"
SRC_URI="x86? mirror://gentoo/${MY_P}.i386.rpm
		ppc? mirror://gentoo/${MY_P}.ppc.rpm"

SLOT="0"
LICENSE="free-noncomm as-is"
KEYWORDS="x86 ~ppc"
IUSE=""

DEPEND="app-arch/rpm2targz"

S="${WORKDIR}/usr"

src_install() {
	BASE_DIR=/opt/XnView

	into /opt
	dobin X11R6/bin/{xnview,nview,nconvert}

	into ${BASE_DIR}
	dolib lib/libformat.so.*
	LIBFORMAT_VER=`ls lib/libformat.so.* | cut -f 3,4 -d .`
	dosym ${BASE_DIR}/lib/libformat.so.${LIBFORMAT_VER} ${BASE_DIR}/lib/libformat.so

	insinto /etc/env.d
	doins ${FILESDIR}/99XnView

	insinto /usr/lib/X11/app-defaults/XnView
	doins X11R6/lib/X11/app-defaults/XnView
	fperms 444 /usr/lib/X11/app-defaults/XnView

	doman local/man/man1/*.1

	dodoc doc/XnView-${PV}/*.txt

	insinto ${BASE_DIR}/Filters/
	doins share/XnView/Filters/*.dat
}
