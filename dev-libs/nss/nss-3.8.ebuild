# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/nss/nss-3.8.ebuild,v 1.25 2004/07/02 04:52:51 eradicator Exp $

inherit eutils

RTM_NAME="NSS_${PV/./_}_RTM"
DESCRIPTION="Mozilla's Netscape Security Services Library that implements PKI support"
HOMEPAGE="http://www.mozilla.org/projects/security/pki/nss/"
SRC_URI="ftp://ftp.mozilla.org/pub/mozilla.org/security/nss/releases/${RTM_NAME}/src/${P}.tar.gz"

LICENSE="MPL-1.1"
SLOT="0"
KEYWORDS="x86 ppc sparc alpha ~amd64 ~ia64 mips hppa"
IUSE=""

DEPEND="virtual/libc
	app-arch/zip
	>=dev-libs/nspr-4.3"

src_unpack() {
	unpack ${A}

	# hack nspr paths
	echo 'INCLUDES += -I/usr/include/nspr -I$(DIST)/include/dbm' \
		>> ${S}/mozilla/security/coreconf/headers.mk || die "failed to append include"

	sed -e 's:$(DIST)/lib/$(LIB_PREFIX)plc4:/usr/lib/$(LIB_PREFIX)plc4:' \
		-e 's:$(DIST)/lib/$(LIB_PREFIX)plds4:/usr/lib/$(LIB_PREFIX)plds4:' \
		-i ${S}/mozilla/security/nss/lib/ckfw/builtins/Makefile
	sed -e 's:$(DIST)/lib/$(LIB_PREFIX)plc4:/usr/lib/$(LIB_PREFIX)plc4:' \
		-e 's:$(DIST)/lib/$(LIB_PREFIX)plds4:/usr/lib/$(LIB_PREFIX)plds4:' \
		-i ${S}/mozilla/security/nss/lib/fortcrypt/swfort/pkcs11/Makefile

	# modify install path
	sed -e 's:SOURCE_PREFIX = $(CORE_DEPTH)/\.\./dist:SOURCE_PREFIX = $(CORE_DEPTH)/dist:' \
		-i ${S}/mozilla/security/coreconf/source.mk

	# workaround to satisfy linux-2.6* (#24626)
	cp ${S}/mozilla/security/coreconf/Linux2.5.mk ${S}/mozilla/security/coreconf/Linux2.6.mk

	if [ "${ARCH}" = "amd64" ]
	then
		cd ${S}; epatch ${FILESDIR}/${PN}-${PV}-amd64.patch
	elif [ "${ARCH}" = "hppa" ]
	then
		cd ${S}
		epatch ${FILESDIR}/${PN}-${PV}-hppa.patch
	fi

	if use mips ; then
		cd ${S}; epatch ${FILESDIR}/${PN}-${PV}-mips.patch
	fi
}

src_compile() {
	cd ${S}/mozilla/security/coreconf

	# Fix for Linux 2.6
	cp Linux2.5.mk Linux2.6.mk

	emake -j1 BUILD_OPT=1 || die "coreconf make failed"
	cd ${S}/mozilla/security/dbm
	emake -j1 BUILD_OPT=1 || die "dbm make failed"
	cd ${S}/mozilla/security/nss
	emake -j1 BUILD_OPT=1 || die "nss make failed"
}

src_install () {
	cd ${S}/mozilla/security/dist

	# put all *.a files in /usr/lib/nss (because some have conflicting names
	# with existing libraries)
	dodir /usr/lib/nss
	cp -L */lib/*.a ${D}/usr/lib/nss || die "copying libs failed"
	dolib */lib/*.so

	# all the include files
	insinto /usr/include/nss
	doins private/nss/*.h
	doins public/nss/*.h

	# NOTE: we ignore the binary files
}
