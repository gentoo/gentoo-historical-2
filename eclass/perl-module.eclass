# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/perl-module.eclass,v 1.123 2010/04/17 19:56:27 tove Exp $
#
# Author: Seemant Kulleen <seemant@gentoo.org>

# @ECLASS: perl-module.eclass
# @MAINTAINER:
# perl@gentoo.org
# @BLURB: eclass for perl modules
# @DESCRIPTION:
# The perl-module eclass is designed to allow easier installation of perl
# modules, and their incorporation into the Gentoo Linux system.

inherit perl-helper eutils base

PERL_EXPF="src_unpack src_compile src_test src_install"

case "${EAPI:-0}" in
	0|1)
		PERL_EXPF="${PERL_EXPF} pkg_setup pkg_preinst pkg_postinst pkg_prerm pkg_postrm"
		;;
	2|3)
		PERL_EXPF="${PERL_EXPF} src_prepare src_configure"
		[[ ${CATEGORY} == "perl-core" ]] && \
			PERL_EXPF="${PERL_EXPF} pkg_postinst pkg_postrm"

		case "${GENTOO_DEPEND_ON_PERL:-yes}" in
			yes)
				DEPEND="dev-lang/perl[-build]"
				RDEPEND="${DEPEND}"
				;;
		esac
		;;
	*)
		DEPEND="EAPI-UNSUPPORTED"
		;;
esac

EXPORT_FUNCTIONS ${PERL_EXPF}

DESCRIPTION="Based on the $ECLASS eclass"

LICENSE="${LICENSE:-|| ( Artistic GPL-1 GPL-2 GPL-3 )}"

[[ -z "${SRC_URI}" && -z "${MODULE_A}" ]] && MODULE_A="${MY_P:-${P}}.tar.gz"
[[ -z "${SRC_URI}" && -n "${MODULE_AUTHOR}" ]] && \
	SRC_URI="mirror://cpan/authors/id/${MODULE_AUTHOR:0:1}/${MODULE_AUTHOR:0:2}/${MODULE_AUTHOR}/${MODULE_SECTION:+${MODULE_SECTION}/}${MODULE_A}"
[[ -z "${HOMEPAGE}" ]] && \
	HOMEPAGE="http://search.cpan.org/dist/${MY_PN:-${PN}}/"

SRC_PREP="no"
SRC_TEST="skip"
PREFER_BUILDPL="yes"

pm_echovar=""
perlinfo_done=false

perl-module_src_unpack() {
	debug-print-function $FUNCNAME "$@"
	base_src_unpack
	has src_prepare ${PERL_EXPF} || perl-module_src_prepare
}

perl-module_src_prepare() {
	debug-print-function $FUNCNAME "$@"
	has src_prepare ${PERL_EXPF} && base_src_prepare
	perl_fix_osx_extra
	esvn_clean
}

perl-module_src_configure() {
	debug-print-function $FUNCNAME "$@"
	perl-module_src_prep
}

perl-module_src_prep() {
	debug-print-function $FUNCNAME "$@"
	[[ ${SRC_PREP} = yes ]] && return 0
	SRC_PREP="yes"

	perl_set_version
	perl_set_eprefix

	export PERL_MM_USE_DEFAULT=1
	# Disable ExtUtils::AutoInstall from prompting
	export PERL_EXTUTILS_AUTOINSTALL="--skipdeps"

	if [[ ${PREFER_BUILDPL} == yes && -f Build.PL ]] ; then
		einfo "Using Module::Build"
		if [[ ${DEPEND} != *virtual/perl-Module-Build* && ${PN} != Module-Build ]] ; then
			ewarn "QA Notice: The ebuild uses Module::Build but doesn't depend on it."
			ewarn "           Add virtual/perl-Module-Build to DEPEND!"
		fi
		set -- \
			--installdirs=vendor \
			--libdoc= \
			--destdir="${D}" \
			--create_packlist=0 \
			${myconf}
		einfo "perl Build.PL" "$@"
		perl Build.PL "$@" <<< "${pm_echovar}" \
				|| die "Unable to build! (are you using USE=\"build\"?)"
	elif [[ -f Makefile.PL ]] ; then
		einfo "Using ExtUtils::MakeMaker"
		set -- \
			PREFIX=${EPREFIX}/usr \
			INSTALLDIRS=vendor \
			INSTALLMAN3DIR='none' \
			DESTDIR="${D}" \
			${myconf}
		einfo "perl Makefile.PL" "$@"
		perl Makefile.PL "$@" <<< "${pm_echovar}" \
				|| die "Unable to build! (are you using USE=\"build\"?)"
	fi
	if [[ ! -f Build.PL && ! -f Makefile.PL ]] ; then
		einfo "No Make or Build file detected..."
		return
	fi
}

perl-module_src_compile() {
	debug-print-function $FUNCNAME "$@"
	perl_set_version

	has src_configure ${PERL_EXPF} || perl-module_src_prep

	if [[ -f Build ]] ; then
		./Build build \
			|| die "compilation failed"
	elif [[ -f Makefile ]] ; then
		emake \
			OTHERLDFLAGS="${LDFLAGS}" \
			${mymake} \
				|| die "compilation failed"
#			OPTIMIZE="${CFLAGS}" \
	fi
}

# For testers:
#  This code attempts to work out your threadingness from MAKEOPTS
#  and apply them to Test::Harness.
#
#  If you want more verbose testing, set TEST_VERBOSE=1
#  in your bashrc | /etc/make.conf | ENV
#
# For ebuild writers:
#  If you wish to enable default tests w/ 'make test' ,
#
#   SRC_TEST="do"
#
#  If you wish to have threads run in parallel ( using the users makeopts )
#  all of the following have been tested to work.
#
#   SRC_TEST="do parallel"
#   SRC_TEST="parallel"
#   SRC_TEST="parallel do"
#   SRC_TEST=parallel
#

perl-module_src_test() {
	debug-print-function $FUNCNAME "$@"
	if has 'do' ${SRC_TEST} || has 'parallel' ${SRC_TEST} ; then
		if has "${TEST_VERBOSE:-0}" 0 && has 'parallel' ${SRC_TEST} ; then
			export HARNESS_OPTIONS=j$(echo -j1 ${MAKEOPTS} | sed -r "s/.*(-j\s*|--jobs=)([0-9]+).*/\2/" )
			einfo "Test::Harness Jobs=${HARNESS_OPTIONS}"
		fi
		${perlinfo_done} || perl_set_version
		if [[ -f Build ]] ; then
			./Build test verbose=${TEST_VERBOSE:-0} || die "test failed"
		elif [[ -f Makefile ]] ; then
			emake test TEST_VERBOSE=${TEST_VERBOSE:-0} || die "test failed"
		fi
	fi
}

perl-module_src_install() {
	debug-print-function $FUNCNAME "$@"

	perl_set_version
	perl_set_eprefix

	local f

	if [[ -z ${mytargets} ]] ; then
		case "${CATEGORY}" in
			dev-perl|perl-core) mytargets="pure_install" ;;
			*)                  mytargets="install" ;;
		esac
	fi

	if [[ -f Build ]] ; then
		./Build ${mytargets} \
			|| die "./Build ${mytargets} failed"
	elif [[ -f Makefile ]] ; then
		emake ${myinst} ${mytargets} \
			|| die "emake ${myinst} ${mytargets} failed"
	fi

	perl_delete_module_manpages
	perl_delete_localpod
	perl_delete_packlist
	perl_remove_temppath

	for f in Change* CHANGES README* TODO FAQ ${mydoc}; do
		[[ -s ${f} ]] && dodoc ${f}
	done

	perl_link_duallife_scripts
}

perl-module_pkg_setup() {
	debug-print-function $FUNCNAME "$@"
	perl_set_version
}

perl-module_pkg_preinst() {
	debug-print-function $FUNCNAME "$@"
	perl_set_version
}

perl-module_pkg_postinst() {
	debug-print-function $FUNCNAME "$@"
	perl_link_duallife_scripts
}

perl-module_pkg_prerm() {
	debug-print-function $FUNCNAME "$@"
}

perl-module_pkg_postrm() {
	debug-print-function $FUNCNAME "$@"
	perl_link_duallife_scripts
}
