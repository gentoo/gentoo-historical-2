# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
#OKV=original kernel version, KV=patched kernel version.  They can be the same.

IUSE="crypt build"

#we use this next variable to avoid duplicating stuff on cvs
OKV=2.4.19
[ "${PR}" == "r0" ] && KV=${OKV}-gentoo || KV=${OKV}-gentoo-${PR}
EXTRAVERSION="`echo ${KV}|sed -e 's:[0-9]\+\.[0-9]\+\.[0-9]\+\(.*\):\1:'`"
S=${WORKDIR}/linux-${KV}
ETYPE="sources"

#Documentation on the patches contained in this kernel will be installed
#to /usr/share/doc/lolo-sources-${PV}/patches.txt.gz

DESCRIPTION="Full sources for the Gentoo Linux kernel"
SRC_URI="http://www.kernel.org/pub/linux/kernel/v2.4/linux-${OKV}.tar.bz2
	 mirror://gentoo/patches-${KV}.tar.bz2"
PROVIDE="virtual/linux-sources"
HOMEPAGE="http://www.kernel.org/ http://www.gentoo.org/" 
LICENSE="GPL-2"
SLOT="${KV}"
KEYWORDS="x86 -ppc -sparc "

if [ $ETYPE = "sources" ]
then
	#console-tools is needed to solve the loadkeys fiasco; binutils version needed to avoid Athlon/PIII/SSE assembler bugs.
	DEPEND="!build? ( >=sys-devel/binutils-2.11.90.0.31 )"
	RDEPEND="${RDEPEND}
		 !build? ( >=sys-libs/ncurses-5.2
			   dev-lang/perl
			   >=sys-apps/modutils-2.4.2
			   sys-devel/make )"
fi

[ -z "$LINUX_HOSTCFLAGS" ] && LINUX_HOSTCFLAGS="-Wall -Wstrict-prototypes -Os -fomit-frame-pointer -I${S}/include"

src_unpack() {
	unpack ${A}
	mv linux-${OKV} linux-${KV} || die

	cd linux-${KV}
	patch -p1 < ${FILESDIR}/lcall-DoS.patch || die "lcall-DoS patch failed"
	patch -p1 < ${FILESDIR}/i810_drm.patch || die "i810_drm patch
failed"
	cd ..

	# Now we need to deal with the tarball of patches.
	cd ${KV} || die "No patch dir to change to"
	[ `use crypt` ] || rm 8*
	#Thers is some anti-grsecurity sentiment, so I'll
	#make it easy not to patch it in.
	#Uncomment the following line to not patch grsecurity.
	#rm 14*

	./addpatches . ${WORKDIR}/linux-${KV} || die

	#fix silly permissions in tarball
	cd ${WORKDIR}
	chown -R 0.0 *
	chmod -R a+r-w+X,u+w *

	cd ${S}
	# Quick Fixes
	patch -p1 < ${FILESDIR}/gentoo-sources-2.4.19-r9-quickfix.patch \
		|| die "Ksyms patch failed"
	# Crypt only quickfix
	[ `use crypt` ] && \
		( patch -p1<${FILESDIR}/gentoo-sources-2.4.19-r9-crypt.patch \
		  || die "crypt patch failed" )
	# Gentoo Linux uses /boot, so fix 'make install' to work properly
	# also fix the EXTRAVERSION
	mv Makefile Makefile.orig
	sed -e 's:#export\tINSTALL_PATH:export\tINSTALL_PATH:' \
	    -e "s:^\(EXTRAVERSION =\).*:\1 ${EXTRAVERSION}:" \
		Makefile.orig >Makefile || die # test, remove me if Makefile ok
	rm Makefile.orig
	
	#sometimes we have icky kernel symbols; this seems to get rid of them
	make distclean || die

	#this file is required for other things to build properly, so we autogenerate it
	make include/linux/version.h || die
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
		cat ${WORKDIR}/${KV}/docs/* > patches.txt
		dodoc patches.txt
		mv ${WORKDIR}/linux* ${D}/usr/src
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
	if [ ! -e ${ROOT}usr/src/linux ]
	then
		rm -f ${ROOT}usr/src/linux
		ln -sf linux-${KV} ${ROOT}/usr/src/linux
	fi
}
