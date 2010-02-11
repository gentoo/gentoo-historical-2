# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/nss/nss-3.12.5-r1.ebuild,v 1.2 2010/02/11 20:52:15 anarchy Exp $

inherit eutils flag-o-matic multilib toolchain-funcs

NSPR_VER="4.8.3-r2"
RTM_NAME="NSS_${PV//./_}_RTM"
DESCRIPTION="Mozilla's Network Security Services library that implements PKI support"
HOMEPAGE="http://www.mozilla.org/projects/security/pki/nss/"
SRC_URI="ftp://ftp.mozilla.org/pub/mozilla.org/security/nss/releases/${RTM_NAME}/src/${P}.tar.gz"
#SRC_URI="http://dev.gentoo.org/~armin76/dist/${P}.tar.bz2
#	mirror://gentoo/${P}.tar.bz2"

LICENSE="|| ( MPL-1.1 GPL-2 LGPL-2.1 )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="utils"

DEPEND="dev-util/pkgconfig"
RDEPEND=">=dev-libs/nspr-${NSPR_VER}
	>=dev-db/sqlite-3.5"

src_unpack() {
	unpack ${A}

	# Custom changes for gentoo
	epatch "${FILESDIR}"/"${PN}"-3.12.5-gentoo-fixups.diff

	cd "${S}"/mozilla/security/coreconf

	# modify install path
	sed -e 's:SOURCE_PREFIX = $(CORE_DEPTH)/\.\./dist:SOURCE_PREFIX = $(CORE_DEPTH)/dist:' \
		-i source.mk

	# Respect LDFLAGS
	sed -i -e 's/\$(MKSHLIB) -o/\$(MKSHLIB) \$(LDFLAGS) -o/g' rules.mk

	# Ensure we stay multilib aware
	sed -i -e "s:gentoo\/nss:$(get_libdir):" "${S}"/mozilla/security/nss/config/Makefile || die "Failed to fix for multilib"
}

src_compile() {
	strip-flags

	echo > "${T}"/test.c
	$(tc-getCC) -c "${T}"/test.c -o "${T}"/test.o
	case $(file "${T}"/test.o) in
	*64-bit*) export USE_64=1;;
	*32-bit*) ;;
	*) die "Failed to detect whether your arch is 64bits or 32bits, disable distcc if you're using it, please";;
	esac

	export BUILD_OPT=1
	export NSS_USE_SYSTEM_SQLITE=1
	export NSPR_INCLUDE_DIR=`pkg-config --cflags-only-I nspr | sed 's/-I//'`
	export NSDISTMODE=copy
	export NSS_ENABLE_ECC=1
	export XCFLAGS="${CFLAGS}"
	export FREEBL_NO_DEPEND=1
	export PKG_CONFIG_ALLOW_SYSTEM_LIBS=1
	export PKG_CONFIG_ALLOW_SYSTEM_CFLAGS=1

	cd "${S}"/mozilla/security/coreconf
	emake -j1 CC="$(tc-getCC)" || die "coreconf make failed"
	cd "${S}"/mozilla/security/dbm
	emake -j1 CC="$(tc-getCC)" || die "dbm make failed"
	cd "${S}"/mozilla/security/nss
	emake -j1 CC="$(tc-getCC)" || die "nss make failed"
}

src_install () {
	MINOR_VERSION=12
	cd "${S}"/mozilla/security/dist

	dodir /usr/$(get_libdir)/nss
	cp -L */lib/*.so "${D}"/usr/$(get_libdir) || die "copying shared libs failed"
	cp -L */lib/*.chk "${D}"/usr/$(get_libdir) || die "copying chk files failed"
	cp -L */lib/libcrmf.a "${D}"/usr/$(get_libdir) || die "copying libs failed"

	# Install nspr-config and pkgconfig file
	dodir /usr/bin
	cp -L */bin/nss-config "${D}"/usr/bin
	dodir /usr/$(get_libdir)/pkgconfig
	cp -L */lib/pkgconfig/nss.pc "${D}"/usr/$(get_libdir)/pkgconfig

	# all the include files
	insinto /usr/include/nss
	doins public/nss/*.h
	cd "${D}"/usr/$(get_libdir)
	for file in *.so; do
		mv ${file} ${file}.${MINOR_VERSION}
		ln -s ${file}.${MINOR_VERSION} ${file}
	done

	if use utils; then
		local nssutil
		nssutils="certutil crlutil cmsutil modutil pk12util signtool signver ssltrap addbuiltin"

		cd "${S}"/mozilla/security/dist/*/bin/
		for f in $nssutils; do
			newbin ${f}
		done
	fi
}

pkg_postinst() {
	elog "We have reverted back to using upstreams soname."
	elog "Please run revdep-rebuild --library libnss3.so.12 , this"
	elog "will correct most issues. If you find a binary that does"
	elog "not run please re-emerge package to ensure it properly"
	elog " links after upgrade."
	elog
}
