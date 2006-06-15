# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/ghc/ghc-6.4.1-r3.ebuild,v 1.9 2006/06/15 12:18:36 dcoutts Exp $

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

# Note to users of hardened gcc-3.x:
#
# If you emerge ghc with hardened gcc it should work fine (because we
# turn off the hardened features that would otherwise break ghc).
# However, emerging ghc while using a vanilla gcc and then switching to
# hardened gcc (using gcc-config) will leave you with a broken ghc. To
# fix it you would need to either switch back to vanilla gcc or re-emerge
# ghc (or ghc-bin). Note that also if you are using hardened gcc-3.x and
# you switch to gcc-4.x that this will also break ghc and you'll need to
# re-emerge ghc (or ghc-bin). People using vanilla gcc can switch between
# gcc-3.x and 4.x with no problems.

inherit base eutils flag-o-matic toolchain-funcs autotools ghc-package check-reqs

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
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="doc X opengl openal"

S="${WORKDIR}/${MY_P}"

PROVIDE="virtual/ghc"

RDEPEND="
	>=sys-devel/gcc-2.95.3
	>=dev-lang/perl-5.6.1
	>=dev-libs/gmp-4.1
	>=sys-libs/readline-4.2
	X? ( || ( x11-libs/libX11 virtual/x11 ) )
	opengl? ( virtual/opengl
			  virtual/glu virtual/glut
			  openal? ( media-libs/openal ) )"

# ghc cannot usually be bootstrapped using later versions ...
DEPEND="${RDEPEND}
	<virtual/ghc-6.5
	!>=virtual/ghc-6.6
	doc? (  ~app-text/docbook-xml-dtd-4.2
			app-text/docbook-xsl-stylesheets
			>=dev-libs/libxslt-1.1.2
			>=dev-haskell/haddock-0.6-r2 )"

PDEPEND=">=dev-haskell/cabal-1.1.3"

pkg_setup() {
	if use openal && ! use opengl; then
		ewarn "The OpenAL bindings require the OpenGL bindings, however"
		ewarn "USE=\"-opengl\" so the OpenAL bindings will not be built."
		ewarn "To build the OpenAL bindings emerge with USE=\"openal opengl\""
	fi

	# Portage's resolution of virtuals fails on virtual/ghc in some Portage
	# releases, the following function causes the build to fail with an
	# informative error message in such a case.
	#if ! has_version virtual/ghc; then
	#	eerror "This ebuild needs a version of GHC to bootstrap from."
	#	eerror "Please emerge dev-lang/ghc-bin to get a binary version."
	#	eerror "You can either use the binary version directly or emerge"
	#	eerror "dev-lang/ghc afterwards."
	#	die "virtual/ghc version required to build"
	#fi
}

append-ghc-cflags() {
	local flag compile assemble link
	for flag in $*; do
		case ${flag} in
			compile)	compile="yes";;
			assemble)	assemble="yes";;
			link)		link="yes";;
			*)
				[[ ${compile}  ]] && GHC_CFLAGS="${GHC_CFLAGS} -optc${flag}"
				[[ ${assemble} ]] && GHC_CFLAGS="${GHC_CFLAGS} -opta${flag}"
				[[ ${link}     ]] && GHC_CFLAGS="${GHC_CFLAGS} -optl${flag}";;
		esac
	done
}

ghc_setup_cflags() {
	# We need to be very careful with the CFLAGS we ask ghc to pass through to
	# gcc. There are plenty of flags which will make gcc produce output that
	# breaks ghc in various ways. The main ones we want to pass through are
	# -mcpu / -march flags. These are important for arches like alpha & sparc.
	# We also use these CFLAGS for building the C parts of ghc, ie the rts.
	strip-flags
	strip-unsupported-flags
	filter-flags -fPIC

	GHC_CFLAGS=""
	for flag in ${CFLAGS}; do
		case ${flag} in

			# Ignore extra optimisation (ghc passes -O to gcc anyway)
			# -O2 and above break on too many systems
			-O*) ;;

			# Arch and ABI flags are what we're really after
			-m*) append-ghc-cflags compile assemble ${flag};;

			# Debugging flags don't help either. You can't debug Haskell code
			# at the C source level and the mangler discards the debug info.
			-g*) ;;

			# Ignore all other flags, including all -f* flags
		esac
	done

	# hardened-gcc needs to be disabled, because the mangler doesn't accept
	# its output.
	gcc-specs-pie && append-ghc-cflags compile link	-nopie
	gcc-specs-ssp && append-ghc-cflags compile		-fno-stack-protector

	# We also add -Wa,--noexecstack to get ghc to generate .o files with
	# non-exectable stack. This it a hack until ghc does it itself properly.
	append-ghc-cflags assemble		"-Wa,--noexecstack"
}

ghc_setup_wrapper() {
	echo '#!/bin/sh'
	echo "GHCBIN=\"$(ghc-libdir)/ghc-$1\";"
	echo "TOPDIROPT=\"-B$(ghc-libdir)\";"
	echo "GHC_CFLAGS=\"${GHC_CFLAGS}\";"
	echo '# Mini-driver for GHC'
	echo 'exec $GHCBIN $TOPDIROPT $GHC_CFLAGS ${1+"$@"}'
}

src_unpack() {
	base_src_unpack
	ghc_setup_cflags

	cd ${S}
	epatch "${FILESDIR}/${PN}-6.4.1-configure.patch"
	epatch "${FILESDIR}/${PN}-6.4.1-openal.patch"
	epatch "${FILESDIR}/${PN}-6.4.1-gcc41.patch"
	epatch "${FILESDIR}/${PN}-6.4.2-sparc32plus.patch"

	# Modify the ghc driver script to use GHC_CFLAGS
	echo "SCRIPT_SUBST_VARS += GHC_CFLAGS" >> "${S}/ghc/driver/ghc/Makefile"
	echo "GHC_CFLAGS = ${GHC_CFLAGS}"      >> "${S}/ghc/driver/ghc/Makefile"
	sed -i -e 's|$TOPDIROPT|$TOPDIROPT $GHC_CFLAGS|' "${S}/ghc/driver/ghc/ghc.sh"

	# Patch to fix parallel make
	sed -i 's/mkDerivedConstants.c : $(H_CONFIG)/mkDerivedConstants.c :	$(H_CONFIG) $(H_PLATFORM)/' "${S}/ghc/includes/Makefile"

	# Patch to fix make-3.81 hanging (backport of the fix in ghc-6.4.2)
	sed -i -e 's/.SECONDARY://' "${S}/mk/suffix.mk"

	# Patch to fix a mis-compilation in the rts due to strict aliasing,
	# should be fixed upstream for 6.4.3 and 6.6. Fixes bug #135651.
	echo 'GC_HC_OPTS += -optc-fno-strict-aliasing' >> "${S}/ghc/rts/Makefile"
}

src_compile() {
	# initialize build.mk
	echo '# Gentoo changes' > mk/build.mk

	# We also need to use the GHC_CFLAGS flags when building ghc itself
	echo "SRC_HC_OPTS+=${GHC_CFLAGS}" >> mk/build.mk
	echo "SRC_CC_OPTS+=${CFLAGS} -Wa,--noexecstack" >> mk/build.mk

	# determine what to do with documentation
	if use doc; then
		echo XMLDocWays="html" >> mk/build.mk
	else
		echo XMLDocWays="" >> mk/build.mk
		# needed to prevent haddock from being called
		echo NO_HADDOCK_DOCS=YES >> mk/build.mk
	fi

	# circumvent a very strange bug that seems related with ghc producing too much
	# output while being filtered through tee (e.g. due to portage logging)
	# reported as bug #111183
	echo "SRC_HC_OPTS+=-fno-warn-deprecations" >> mk/build.mk

	# force the config variable ArSupportsInput to be unset;
	# ar in binutils >= 2.14.90.0.8-r1 seems to be classified
	# incorrectly by the configure script
	echo "ArSupportsInput:=" >> mk/build.mk

	# Required for some architectures, because they don't support ghc fully ...
	use alpha || use hppa || use ppc64 && echo "GhcWithInterpreter=NO" >> mk/build.mk
	use alpha || use hppa && echo "GhcUnregisterised=YES" >> mk/build.mk

	# On the other hand some arches do support some ghc features even though
	# they're off by default
	use ia64 && echo "GhcWithInterpreter=YES" >> mk/build.mk

	# The SplitObjs feature doesn't work on several arches and it makes
	# 'ar' take loads of RAM:
	CHECKREQS_MEMORY="200"
	if use alpha || use hppa || use ppc64; then
		echo "SplitObjs=NO" >> mk/build.mk
	elif ! check_reqs_conditional; then
		einfo "Turning off ghc's 'Split Objs' feature because this machine"
		einfo "does not have enough RAM for it. This will have the effect"
		einfo "of making binaries produced by ghc considerably larger."
		echo "SplitObjs=NO" >> mk/build.mk
	fi

	GHC_CFLAGS="" ghc_setup_wrapper $(ghc-version) > "${TMP}/ghc.sh"
	chmod +x "${TMP}/ghc.sh"

	# we've patched some configure.ac files do allow us to enable/disable the
	# X11 and HGL packages, so we need to autoreconf.
	eautoreconf

	econf \
		--with-ghc="${TMP}/ghc.sh" \
		$(use_enable opengl opengl) \
		$(use_enable opengl glut) \
		$(use openal && use opengl \
			&& echo --enable-openal \
			|| echo --disable-openal) \
		$(use_enable X x11) \
		$(use_enable X hgl) \
		|| die "econf failed"

	emake all datadir="/usr/share/doc/${PF}" || die "make failed"
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
	ewarn "If you have upgraded from another version of ghc or"
	ewarn "if you have switched from ghc-bin to ghc, please run:"
	ewarn "	/usr/sbin/ghc-updater"
	ewarn "to re-merge all ghc-based Haskell libraries."
}

