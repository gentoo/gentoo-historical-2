# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/splashutils/splashutils-0.9.1.ebuild,v 1.5 2005/03/08 17:34:22 spock Exp $

MISCSPLASH="miscsplashutils-0.1.2"
GENTOOSPLASH="splashutils-gentoo-0.1.4"
KLIBC_VERSION="0.179"

DESCRIPTION="Framebuffer splash utilities."
HOMEPAGE="http://dev.gentoo.org/~spock/"
SRC_URI="mirror://gentoo/${P/_/-}.tar.bz2
	 mirror://gentoo/${MISCSPLASH}.tar.bz2
	 mirror://gentoo/${GENTOOSPLASH}.tar.bz2
	 mirror://gentoo/fbsplash-theme-emergence-r2.tar.bz2
	 mirror://gentoo/fbsplash-theme-gentoo-r1.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64 ~ppc"
IUSE="hardened"
RDEPEND=">=media-libs/freetype-2
	>=media-libs/libpng-1.2.7
	>=media-libs/jpeg-6b
	>=sys-apps/baselayout-1.9.4-r5
	!media-gfx/bootsplash"
DEPEND="${RDEPEND}
	virtual/linux-sources"

S="${WORKDIR}/${P/_/-}"
SM="${WORKDIR}/${MISCSPLASH}"
SG="${WORKDIR}/${GENTOOSPLASH}"

pkg_setup() {
	if use hardened; then
		ewarn "Due to problems with klibc, it is currently impossible to compile splashutils"
		ewarn "with 'hardened' GCC flags. As a workaround, the package will be compiled with"
		ewarn "-fno-stack-protector. Hardened GCC features will not be used while building"
		ewarn "the fbsplash kernel helper."
	fi
}

src_unpack() {
	unpack ${A}
	ln -s /usr/src/linux ${S}/linux
	if [ ! -e /usr/src/linux/include/linux/console_splash.h ]; then
		eerror "Your kernel in /usr/src/linux has not been patched with a compatible version"
		eerror "of fbsplash. Please download the latest patch from http://dev.gentoo.org/~spock/"
		eerror "and patch your kernel."
		die "Fbsplash not found"
	fi

	if [ ! -e /usr/src/linux/include/asm ]; then
		if [ -z "${KBUILD_OUTPUT}" ] ||
		   [ ! -e "${KBUILD_OUTPUT}/include/asm" ]; then
			eerror "It appears that your kernel has not been configured. Please run at least"
			eerror "\`make prepare\` before merging splashutils."
			die "Kernel not configured"
		else
			t=$(readlink ${KBUILD_OUTPUT}/include/asm)
			ln -s /usr/src/linux/include/${t} ${T}/asm
			sed -e "s@#CHANGEME#@${T}/@" -i ${S}/libs/klibc-${KLIBC_VERSION}/klibc/makeerrlist.pl
		fi
	fi

	# this should make this version of splashutils compile with hardened systems
	if use hardened; then
		sed -e 's@K_CFLAGS =@K_CFLAGS = -fno-stack-protector@' -i ${S}/Makefile
		sed -e 's@CFLAGS  =@CFLAGS  = -fno-stack-protector@' -i ${S}/libs/klibc-${KLIBC_VERSION}/klibc/MCONFIG
	fi
}

src_compile() {

	local miscincs

	if [ -n "${KBUILD_OUTPUT}" ]; then
		miscincs="-I${T} -I${KBUILD_OUTPUT}/include"
	fi

	emake -j1 MISCINCS="${miscincs}"

	cd ${SM}
	emake
}

src_install() {
	cd ${SM}
	make DESTDIR=${D} install || die

	cd ${S}
	make DESTDIR=${D} install || die

	exeinto /sbin
	doexe ${SG}/splash

	exeinto /etc/init.d
	newexe ${SG}/init-splash splash

	insinto /sbin
	doins ${SG}/splash-functions.sh

	insinto /etc/conf.d
	newins ${SG}/splash.conf splash

	dodir /etc/splash/{emergence,gentoo}
	cp -pR ${WORKDIR}/{emergence,gentoo} ${D}/etc/splash
	ln -s emergence ${D}/etc/splash/default
	dodoc docs/* README AUTHORS

	if [ ! -e ${ROOT}/etc/splash/default ]; then
		dosym /etc/splash/emergence /etc/splash/default
	fi
}
