# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnustep-base/gnustep-make/gnustep-make-2.0.7.ebuild,v 1.1 2008/12/22 12:54:26 voyageur Exp $

EAPI=2

inherit gnustep-base eutils

DESCRIPTION="GNUstep Makefile Package"

HOMEPAGE="http://www.gnustep.org"
SRC_URI="ftp://ftp.gnustep.org/pub/gnustep/core/${P}.tar.gz"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE=""
SLOT="0"
LICENSE="GPL-2"

DEPEND="${GNUSTEP_CORE_DEPEND}
	sys-devel/gcc[objc]
	>=sys-devel/make-3.75"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-2.0.1-destdir.patch
}

src_configure() {
	local myconf
	myconf="--prefix=${GNUSTEP_PREFIX} --with-layout=gnustep"
	myconf="$myconf --with-config-file=/etc/GNUstep/GNUstep.conf"
	myconf="$myconf --enable-native-objc-exceptions"
	econf $myconf || die "configure failed"
}

src_compile() {
	emake || die "compilation failed"
	# Prepare doc here (needed when no gnustep-make is already installed)
	if use doc ; then
		# If a gnustep-1 environment is set
		unset GNUSTEP_MAKEFILES
		cd Documentation
		emake -j1 all install || die "doc make has failed"
		cd ..
	fi
}

src_install() {
	# Get GNUSTEP_* variables
	. ./GNUstep.conf

	local make_eval="-j1"
	use debug || make_eval="${make_eval} debug=no"
	make_eval="${make_eval} verbose=yes"

	emake ${make_eval} DESTDIR="${D}" install || die "install has failed"

	# Copy the documentation
	if use doc ; then
		dodir ${GNUSTEP_SYSTEM_LIBRARY}
		cp -r Documentation/tmp-installation/System/Library/Documentation \
			"${D}"${GNUSTEP_SYSTEM_LIBRARY}
	fi

	dodoc FAQ README RELEASENOTES

	exeinto /etc/profile.d
	doexe "${FILESDIR}"/gnustep-2.sh
	doexe "${FILESDIR}"/gnustep-2.csh

	dodir /etc/env.d
	cat <<- EOF > "${D}"/etc/env.d/99gnustep
PATH=${GNUSTEP_SYSTEM_TOOLS}:${GNUSTEP_LOCAL_TOOLS}
ROOTPATH=${GNUSTEP_SYSTEM_TOOLS}:${GNUSTEP_LOCAL_TOOLS}
LDPATH=${GNUSTEP_SYSTEM_LIBRARIES}:${GNUSTEP_LOCAL_LIBRARIES}
MANPATH=${GNUSTEP_SYSTEM_DOC_MAN}:${GNUSTEP_LOCAL_DOC_MAN}
INFOPATH=${GNUSTEP_SYSTEM_DOC_INFO}:${GNUSTEP_LOCAL_DOC_INFO}
INFODIR=${GNUSTEP_SYSTEM_DOC_INFO}:${GNUSTEP_LOCAL_DOC_INFO}
EOF
}
