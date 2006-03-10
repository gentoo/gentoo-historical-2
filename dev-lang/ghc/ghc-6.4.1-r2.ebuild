# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/ghc/ghc-6.4.1-r2.ebuild,v 1.3 2006/03/10 23:14:23 dcoutts Exp $

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

inherit base eutils autotools ghc-package check-reqs

DESCRIPTION="The Glasgow Haskell Compiler"
HOMEPAGE="http://www.haskell.org/ghc/"

# discover if this is a snapshot release
IS_SNAPSHOT="${PV%%*pre*}" # zero if snapshot
MY_PV="${PV/_pre/.}"
MY_P="${PN}-${MY_PV}"
EXTRA_SRC_URI="${MY_PV}"
[[ -z "${IS_SNAPSHOT}" ]] && EXTRA_SRC_URI="stable/dist"

SRC_URI="http://www.haskell.org/ghc/dist/${EXTRA_SRC_URI}/${MY_P}-src.tar.bz2"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="doc X opengl openal"
#java use flag disabled because of bug #106992

S="${WORKDIR}/${MY_P}"

PROVIDE="virtual/ghc"

RDEPEND="
	>=sys-devel/gcc-2.95.3
	>=dev-lang/perl-5.6.1
	>=dev-libs/gmp-4.1
	>=sys-libs/readline-4.2
	X? ( || ( x11-libs/libX11 virtual/x11 ) )
	opengl? ( virtual/opengl virtual/glu virtual/glut )
	openal? ( media-libs/openal )"

# ghc cannot usually be bootstrapped using later versions ...
DEPEND="${RDEPEND}
	<virtual/ghc-6.5
	!>=virtual/ghc-6.6
	doc? (  ~app-text/docbook-xml-dtd-4.2
		app-text/docbook-xsl-stylesheets
		>=dev-libs/libxslt-1.1.2
		>=dev-haskell/haddock-0.6-r2 )"
# removed: java? ( >=dev-java/fop-0.20.5 )

PDEPEND=">=dev-haskell/cabal-1.1.3"

# hardened-gcc needs to be disabled, because the mangler doesn't accept
# its output.
GHC_CFLAGS="-optc-nopie -optl-nopie -optc-fno-stack-protector"

# We also add -opta-Wa,--noexecstack to get ghc to generate .o files with
# non-exectable stack. This it a hack until ghc does it itself properly.
GHC_CFLAGS="${GHC_CFLAGS} -opta-Wa,--noexecstack"

# Portage's resolution of virtuals fails on virtual/ghc in some Portage releases,
# the following function causes the build to fail with an informative error message
# in such a case.
# pkg_setup() {
# 	if ! has_version virtual/ghc; then
# 		eerror "This ebuild needs a version of GHC to bootstrap from."
# 		eerror "Please emerge dev-lang/ghc-bin to get a binary version."
# 		eerror "You can either use the binary version directly or emerge"
# 		eerror "dev-lang/ghc afterwards."
# 		die "virtual/ghc version required to build"
# 	fi
# }

src_unpack() {
	base_src_unpack

	cd ${S}
	epatch "${FILESDIR}/${PN}-6.4.1-configure.patch"
	epatch "${FILESDIR}/${PN}-6.4.1-openal.patch"

	# Modify the ghc driver script to use GHC_CFLAGS
	echo "SCRIPT_SUBST_VARS += GHC_CFLAGS" >> "${S}/ghc/driver/ghc/Makefile"
	echo "GHC_CFLAGS = ${GHC_CFLAGS}"      >> "${S}/ghc/driver/ghc/Makefile"
	sed -i -e 's|$TOPDIROPT|$TOPDIROPT $GHC_CFLAGS|' "${S}/ghc/driver/ghc/ghc.sh"
}

src_compile() {
	# initialize build.mk
	echo '# Gentoo changes' > mk/build.mk

	# We also need to use the GHC_CFLAGS flags when building ghc itself
	echo "SRC_HC_OPTS+=${GHC_CFLAGS}" >> mk/build.mk

	# determine what to do with documentation
	local mydoc
	if use doc; then
		mydoc="html"
#		if use java; then
#			mydoc="${mydoc} ps"
#		fi
	else
		mydoc=""
		# needed to prevent haddock from being called
		echo NO_HADDOCK_DOCS=YES >> mk/build.mk
	fi
	echo XMLDocWays="${mydoc}" >> mk/build.mk

	# circumvent a very strange bug that seems related with ghc producing too much
	# output while being filtered through tee (e.g. due to portage logging)
	# reported as bug #111183
	echo "SRC_HC_OPTS+=-fno-warn-deprecations" >> mk/build.mk

	# force the config variable ArSupportsInput to be unset;
	# ar in binutils >= 2.14.90.0.8-r1 seems to be classified
	# incorrectly by the configure script
	echo "ArSupportsInput:=" >> mk/build.mk

	# Required for some architectures, because they don't support ghc fully ...
	use hppa || use alpha || use ppc64 && echo "GhcWithInterpreter=NO" >> mk/build.mk
	use hppa || use alpha && echo "GhcUnregisterised=YES" >> mk/build.mk

	# The SplitObjs feature doesn't work on several arches and it makes
	# 'ar' take loads of RAM:
	CHECKREQS_MEMORY="200"
	if use alpha || use ppc || use ppc64 || use sparc; then
		echo "SplitObjs=NO" >> mk/build.mk
	elif ! check_reqs_conditional; then
		einfo "Turning off ghc's 'Split Objs' feature because this machine"
		einfo "does not have enough RAM for it. This will have the effect"
		einfo "of making binaries produced by ghc considerably larger."
		echo "SplitObjs=NO" >> mk/build.mk
	fi

	# we've patched some configure.ac files do allow us to enable/disable the
	# X11 and HGL packages, so we need to autoreconf.
	eautoreconf

	econf \
		$(use_enable opengl opengl) \
		$(use_enable opengl glut) \
		$(use_enable openal openal) \
		$(use_enable X x11) \
		$(use_enable X hgl) \
		|| die "econf failed"

	# the build does not seem to work all that
	# well with parallel make
	emake -j1 all datadir="/usr/share/doc/${PF}" || die "make failed"
	# the explicit datadir is required to make the haddock entries
	# in the package.conf file point to the right place ...

}

src_install () {
	local insttarget

	insttarget="install"
	use doc && insttarget="${insttarget} install-docs"

	# the libdir0 setting is needed for amd64, and does not
	# harm for other arches
	emake -j1 ${insttarget} \
		prefix="${D}/usr" \
		datadir="${D}/usr/share/doc/${PF}" \
		infodir="${D}/usr/share/info" \
		mandir="${D}/usr/share/man" \
		libdir0="${D}/usr/$(get_libdir)" \
		|| die "make ${insttarget} failed"

	#need to remove ${D} from ghcprof script
	cd "${D}/usr/bin"
	mv ghcprof ghcprof-orig
	sed -e 's:$FPTOOLS_TOP_ABS:#$FPTOOLS_TOP_ABS:' ghcprof-orig > ghcprof
	chmod a+x ghcprof
	rm -f ghcprof-orig

	cd "${S}/ghc"
	dodoc README ANNOUNCE LICENSE VERSION

	dosbin ${FILESDIR}/ghc-updater
}

pkg_postinst () {
	ebegin "Unregistering ghc's built-in cabal "
	$(ghc-getghcpkg) unregister Cabal > /dev/null
	eend $?
	ghc-reregister
	einfo "If you have dev-lang/ghc-bin installed, you might"
	einfo "want to unmerge it. It is no longer needed."
	einfo
	ewarn "IMPORTANT:"
	ewarn "If you upgrade from another ghc version, please run"
	ewarn "/usr/sbin/ghc-updater to re-merge all ghc-based"
	ewarn "Haskell libraries."
}

