# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/haskell-cabal.eclass,v 1.4 2006/02/16 14:10:51 dcoutts Exp $
#
# Original authors: Andres Loeh <kosmikus@gentoo.org>
#                   Duncan Coutts <dcoutts@gentoo.org>
# Maintained by: Haskell herd <haskell@gentoo.org>
#
# This eclass is for packages that make use of the
# Haskell Common Architecture for Building Applications
# and Libraries (cabal).
#
# Basic instructions:
#
# Before inheriting the eclass, set CABAL_FEATURES to
# reflect the tools and features that the package makes
# use of.
#
# Currently supported features:
#   haddock    --  for documentation generation
#   alex       --  lexer/scanner generator
#   happy      --  parser generator
#   c2hs       --  C interface generator
#   cpphs      --  C preprocessor clone written in Haskell
#   profile    --  if package supports to build profiling-enabled libraries
#   bootstrap  --  only used for the cabal package itself
#   bin        --  the package installs binaries
#   lib        --  the package installs libraries
#
# Dependencies on other cabal packages have to be specified
# correctly.
#
# Cabal libraries should usually be SLOTted with "${PV}".
#
# Many Cabal packages require S to be manually set.
#
# Conforming Cabal packages don't require any function definitions
# in the ebuild.

inherit ghc-package


for feature in ${CABAL_FEATURES}; do
	case ${feature} in
		haddock)   CABAL_USE_HADDOCK=yes;;
		alex)      CABAL_USE_ALEX=yes;;
		happy)     CABAL_USE_HAPPY=yes;;
		c2hs)      CABAL_USE_C2HS=yes;;
		cpphs)     CABAL_USE_CPPHS=yes;;
		profile)   CABAL_USE_PROFILE=yes;;
		bootstrap) CABAL_BOOTSTRAP=yes;;
		bin)       CABAL_HAS_BINARIES=yes;;
		lib)       CABAL_HAS_LIBRARIES=yes;;
		*) CABAL_UNKNOWN="${CABAL_UNKNOWN} ${feature}";;
	esac
done

if [[ -n "${CABAL_USE_HADDOCK}" ]]; then
	IUSE="${IUSE} doc"
	DEPEND="${DEPEND} doc? ( dev-haskell/haddock )"
	cabalconf="${cabalconf} --with-haddock=/usr/bin/haddock"
fi

if [[ -n "${CABAL_USE_ALEX}" ]]; then
	DEPEND="${DEPEND} dev-haskell/alex"
	cabalconf="${cabalconf} --with-alex=/usr/bin/alex"
fi

if [[ -n "${CABAL_USE_HAPPY}" ]]; then
	DEPEND="${DEPEND} dev-haskell/happy"
	cabalconf="${cabalconf} --with-happy=/usr/bin/happy"
fi

if [[ -n "${CABAL_USE_C2HS}" ]]; then
	DEPEND="${DEPEND} dev-haskell/c2hs"
	cabalconf="${cabalconf} --with-c2hs=/usr/bin/c2hs"
fi

if [[ -n "${CABAL_USE_CPPHS}" ]]; then
	DEPEND="${DEPEND} dev-haskell/cpphs"
	cabalconf="${cabalconf} --with-cpphs=/usr/bin/cpphs"
fi

if [[ -n "${CABAL_USE_PROFILE}" ]]; then
	IUSE="${IUSE} profile"
fi

# We always use a standalone version of Cabal, rather than the one that comes
# with GHC. But of course we can't depend on cabal when building cabal itself.
if [[ -z "${CABAL_BOOTSTRAP}" ]]; then
	DEPEND="${DEPEND} >=dev-haskell/cabal-1.1.3"
fi

# Libraries require GHC to be installed.
if [[ -n "${CABAL_HAS_LIBRARIES}" ]]; then
	RDEPEND="${RDEPEND} virtual/ghc"
fi

cabal-bootstrap() {
	local setupmodule
	local cabalversion
	if [[ -f "${S}/Setup.lhs" ]]; then
		setupmodule="${S}/Setup.lhs"
	else
		if [[ -f "${S}/Setup.hs" ]]; then
			setupmodule="${S}/Setup.hs"
		else
			die "No Setup.lhs or Setup.hs found"
		fi
	fi

	# We build the setup program using the latest version of
	# cabal that we have installed
	cabalversion=$(ghc-bestcabalversion)
	einfo "Using ${cabalversion}."
	$(ghc-getghc) -package "${cabalversion}" --make "${setupmodule}" -o setup \
		|| die "compiling ${setupmodule} failed"
}

cabal-haddock() {
	./setup haddock || die "setup haddock failed"
}

cabal-configure() {
	if [[ -n "${CABAL_USE_PROFILE}" ]] && use profile; then
		cabalconf="${cabalconf} --enable-executable-profiling";
		cabalconf="${cabalconf} --enable-library-profiling"
	fi

	./setup configure \
		--ghc --prefix=/usr \
		--with-compiler="$(ghc-getghc)" \
		--with-hc-pkg="$(ghc-getghcpkg)" \
		${cabalconf} \
		"$@" || die "setup configure failed"
}

cabal-build() {
	./setup build \
		|| die "setup build failed"
}

cabal-copy() {
	./setup copy \
		--copy-prefix="${D}/usr" \
		|| die "setup copy failed"

	# cabal is a bit eager about creating dirs,
	# so remove them if they are empty
	rmdir "${D}/usr/bin" 2> /dev/null

	# GHC 6.4 has a bug in get/setPermission and Cabal 1.1.1 has
	# no workaround.
	# set the +x permission on executables
	if [[ -d "${D}/usr/bin" ]] ; then
		chmod +x "${D}/usr/bin/"*
	fi
}

cabal-pkg() {
	# This does not actually register since we're using /usr/bin/true instead
	# of ghc-pkg. So it just leaves the .installed-pkg-config and we can
	# register that ourselves (if it exists).
	local result
	local err

	if [[ -n ${CABAL_HAS_LIBRARIES} ]]; then
		sed -i 's:ghc-pkg:/usr/bin/true:' .setup-config
		./setup register || die "setup register failed"
		if [[ -f .installed-pkg-config ]]; then
			ghc-setup-pkg .installed-pkg-config
			ghc-install-pkg
		else
			die "setup register has not generated a package configuration file"
		fi
	fi
}

# exported function: check if cabal is correctly installed for
# the currently active ghc (we cannot guarantee this with portage)
haskell-cabal_pkg_setup() {
	if [[ -z "${CABAL_BOOTSTRAP}" ]] && ! ghc-sanecabal "1.1.3"; then
		eerror "The package dev-haskell/cabal is not correctly installed for"
		eerror "the currently active version of ghc ($(ghc-version)). Please"
		eerror "run ghc-updater or re-emerge dev-haskell/cabal."
		die "cabal is not correctly installed"
	fi
	if [[ -z "${CABAL_HAS_BINARIES}" ]] && [[ -z "${CABAL_HAS_LIBRARIES}" ]]; then
		eerror "QA: Neither bin nor lib are in CABAL_FEATURES."
	fi
	if [[ -n "${CABAL_UNKNOWN}" ]]; then
		ewarn "Unknown entry in CABAL_FEATURES: ${CABAL_UNKNONW}"
	fi
}

# exported function: cabal-style bootstrap configure and compile
cabal_src_compile() {
	cabal-bootstrap
	cabal-configure
	cabal-build

	if [[ -n "${CABAL_USE_HADDOCK}" ]] && use doc; then
		cabal-haddock
	fi
}
haskell-cabal_src_compile() {
	cabal_src_compile
}

# exported function: cabal-style copy and register
cabal_src_install() {
	cabal-copy
	cabal-pkg

	if [[ -n "${CABAL_USE_HADDOCK}" ]] && use doc; then
		dohtml dist/doc/html/*
	fi
}
haskell-cabal_src_install() {
	cabal_src_install
}

EXPORT_FUNCTIONS pkg_setup src_compile src_install
