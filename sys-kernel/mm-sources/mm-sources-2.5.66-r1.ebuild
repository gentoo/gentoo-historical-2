# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/mm-sources/mm-sources-2.5.66-r1.ebuild,v 1.1 2003/03/26 15:31:14 sethbc Exp $
#OKV=original kernel version, KV=patched kernel version.  They can be the same.

OKV=${PV}
if [ "${PR}" != "r0" ]; then 
	PATCH_URI="http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.5/${PV}/${PVR/r/mm}/${PVR/r/mm}.gz"
fi
KV=${PVR/r/mm}
S=${WORKDIR}/linux-${KV}
ETYPE="sources"

# What's in this kernel?

# INCLUDED:
# The development branch of the linux kernel with Andrew Morton's patch

DESCRIPTION="Full sources for the development linux kernel with Andrew Morton's patchset"
SRC_URI="http://www.kernel.org/pub/linux/kernel/v2.5/linux-${OKV}.tar.bz2 ${PATCH_URI}"
PROVIDE="virtual/linux-sources"
HOMEPAGE="http://www.kernel.org/ http://www.gentoo.org/" 
LICENSE="GPL-2"
SLOT="${KV}"
KEYWORDS="x86 ppc"

if [ $ETYPE = "sources" ] && [ -z "`use build`" ]
then
	#console-tools is needed to solve the loadkeys fiasco; binutils version needed to avoid Athlon/PIII/SSE assembler bugs.
	DEPEND=">=sys-devel/binutils-2.11.90.0.31"
	RDEPEND=">=sys-libs/ncurses-5.2 dev-lang/perl
		 sys-devel/make"
fi

[ -z "$LINUX_HOSTCFLAGS" ] && LINUX_HOSTCFLAGS="-Wall -Wstrict-prototypes -O2 -fomit-frame-pointer -I${S}/include"

src_unpack() {
	cd ${WORKDIR}
	unpack linux-${OKV}.tar.bz2

	if [ "${PATCH_URI}" ]; then
		mv linux-${OKV} linux-${KV}
		cd ${S}
		zcat ${DISTDIR}/${PVR/r/mm}.gz | patch -p1 -l || \
			die "akpm patch application failure"
		sed -e "s:^EXTRAVERSION.*$:EXTRAVERSION = -${PR/r/mm}:" \
			Makefile > Makefile.new
		mv Makefile.new Makefile
	else
		cd ${S}
	fi

	#sometimes we have icky kernel symbols; this seems to get rid of them
	make mrproper || die

	#fix silly permissions in tarball
	cd ${WORKDIR}
	chown -R 0.0 *
	chmod -R a+r-w+X,u+w *

}

src_compile() {
	if [ "$ETYPE" = "headers" ]
	then
		yes "" | make oldconfig		
		echo "Ignore any errors from the yes command above."
	fi
}

src_install() {
	if [ "$ETYPE" = "sources" ]
	then
		dodir /usr/src
		echo ">>> Copying sources..."
		mv ${WORKDIR}/* ${D}/usr/src
	else
		#linux-headers
		dodir /usr/include/linux
		cp -ax ${S}/include/linux/* ${D}/usr/include/linux
		rm -rf ${D}/usr/include/linux/modules
		dodir /usr/include/asm
		cp -ax ${S}/include/asm-i386/* ${D}/usr/include/asm
	fi
}

pkg_preinst() {
	if [ "$ETYPE" = "headers" ] 
	then
		[ -L ${ROOT}usr/include/linux ] && rm ${ROOT}usr/include/linux
		[ -L ${ROOT}usr/include/asm ] && rm ${ROOT}usr/include/asm
		true
	fi
}

pkg_postinst() {
	[ "$ETYPE" = "headers" ] && return
	if [ ! -e ${ROOT}usr/src/linux-beta ]
	then

		ln -sf linux-${KV} ${ROOT}/usr/src/linux-beta
	fi
}
