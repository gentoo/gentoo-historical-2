# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/ghc/ghc-6.2.2.ebuild,v 1.2 2004/10/23 23:14:49 mattam Exp $

# Brief explanation of the bootstrap logic:
#
# ghc requires ghc-bin to bootstrap.
# Therefore, 
# (1) both ghc-bin and ghc provide virtual/ghc
# (2) virtual/ghc *must* default to ghc-bin
# (3) ghc depends on virtual/ghc
#
# This solution has the advantage that the binary distribution
# can be removed once an forall after the first succesful install
# of ghc.

inherit base flag-o-matic eutils

IUSE="doc tetex opengl"

DESCRIPTION="The Glasgow Haskell Compiler"
HOMEPAGE="http://www.haskell.org/ghc/"

SRC_URI="http://www.haskell.org/ghc/dist/${PV}/ghc-${PV}-src.tar.bz2"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~x86 ~ppc -alpha"


PROVIDE="virtual/ghc"
# FIXME: Add USE support for parallel haskell (requires PVM)
#	 Get PVM from ftp://ftp.netlib.org/pvm3/
DEPEND="virtual/ghc
	>=dev-lang/perl-5.6.1
	>=sys-devel/gcc-2.95.3
	>=sys-devel/make-3.79.1
	>=sys-apps/sed-3.02.80
	>=sys-devel/flex-2.5.4a
	>=dev-libs/gmp-4.1
	doc? ( >=app-text/openjade-1.3.1
		>=app-text/sgml-common-0.6.3
		~app-text/docbook-sgml-dtd-3.1
		>=app-text/docbook-dsssl-stylesheets-1.64
		>=dev-haskell/haddock-0.6-r2
		tetex? ( virtual/tetex
			>=app-text/jadetex-3.12 ) )
	opengl? ( virtual/opengl
		virtual/glu
		virtual/glut )"

RDEPEND="virtual/libc
	>=sys-devel/gcc-2.95.3
	>=dev-lang/perl-5.6.1
	>=dev-libs/gmp-4.1
	opengl? ( virtual/opengl virtual/glu virtual/glut )"

# extend path to /opt/ghc/bin to guarantee that ghc-bin is found
GHCPATH="${PATH}:/opt/ghc/bin"

SUPPORTED_CFLAGS=""

# Setup supported CFLAGS.
setup_cflag() {
	OLD_CFLAGS="${CFLAGS}"
	CFLAGS="${CFLAGS} $1"
	strip-unsupported-flags

	if [ "${OLD_CFLAGS}" != "${CFLAGS}" ];
	then
		SUPPORTED_CFLAGS="$1 ${SUPPORTED_CFLAGS}"
	fi
}

setup_cflags() {
	setup_cflag "-fno-pic"
	setup_cflag "-fno-stack-protector"
}

src_unpack() {
	base_src_unpack

	# hardened-gcc needs to be disabled, because the
	# mangler doesn't accept its output; yes, the 6.2 version
	# should do ...
	cd ${S}/ghc
	pushd driver
	setup_cflags
	epatch ${FILESDIR}/${PN}-6.2.hardened.patch
	sed -i -e "s|@GHC_CFLAGS@|${SUPPORTED_CFLAGS//-f/-optc-f}|" ghc/ghc.sh
	sed -i -e "s|@GHC_CFLAGS@|${SUPPORTED_CFLAGS//-f/-optc-f}|" ghci/ghci.sh
	popd
}

src_compile() {
	local myconf
	if use opengl; then
		myconf="--enable-hopengl"
	fi

	# disable the automatic PIC building which is considered as Prologue Junk by the Haskell Compiler
	# thanks to Peter Simons for finding this and giving notice on bugs.gentoo.org
	# (this is still necessary, even though we have the patch, because
	# we might be bootstrapping from a version that didn't have the
	# patch included)
	setup_cflags
	echo "SRC_CC_OPTS+=${SUPPORTED_CFLAGS}" >> mk/build.mk
	echo "SRC_HC_OPTS+=${SUPPORTED_CFLAGS//-f/-optc-f}" >> mk/build.mk

	# force the config variable ArSupportsInput to be unset;
	# ar in binutils >= 2.14.90.0.8-r1 seems to be classified
	# incorrectly by the configure script
	echo "ArSupportsInput:=" >> mk/build.mk

	# Required under ppc to work around some obscure linker problem.
	if use ppc;
	then
		echo "SplitObjs=NO" >> mk/build.mk
	fi

	# unset SGML_CATALOG_FILES because documentation installation
	# breaks otherwise ...
	# (--enable-threaded-rts is no longer needed)
	PATH="${GHCPATH}" SGML_CATALOG_FILES="" econf \
		${myconf} || die "econf failed"

	# the build does not seem to work all that
	# well with parallel make
	emake -j1 || die "make failed"

	# if documentation has been requested, build documentation ...
	if use doc; then
		emake -j1 html || die "make html failed"
		if use tetex; then
			emake -j1 ps || die "make ps failed"
		fi
	fi

}

src_install () {
	local mydoc
	local insttarget

	insttarget="install"

	# determine what to do with documentation
	if use doc; then
		mydoc="html"
		insttarget="${insttarget} install-docs"
		if use tetex; then
			mydoc="${mydoc} ps"
		fi
	else
		mydoc=""
		# needed to prevent haddock from being called
		echo NO_HADDOCK_DOCS=YES >> mk/build.mk
	fi
	echo SGMLDocWays="${mydoc}" >> mk/build.mk

	emake -j1 ${insttarget} \
		prefix="${D}/usr" \
		datadir="${D}/usr/share/doc/${PF}" \
		infodir="${D}/usr/share/info" \
		mandir="${D}/usr/share/man" \
		|| die "make ${insttarget} failed"

	#need to remove ${D} from ghcprof script
	cd ${D}/usr/bin
	mv ghcprof ghcprof-orig
	sed -e 's:$FPTOOLS_TOP_ABS:#$FPTOOLS_TOP_ABS:' ghcprof-orig > ghcprof
	chmod a+x ghcprof
	rm -f ghcprof-orig

	cd ${S}/ghc
	dodoc README ANNOUNCE LICENSE VERSION
}


pkg_postinst () {
	einfo "If you have dev-lang/ghc-bin installed, you might"
	einfo "want to unmerge it again. It is no longer needed."
}
