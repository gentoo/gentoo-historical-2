# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/perl-module.eclass,v 1.112 2008/09/30 08:28:44 robbat2 Exp $
#
# Author: Seemant Kulleen <seemant@gentoo.org>
# Maintained by the Perl herd <perl@gentoo.org>
#
# The perl-module eclass is designed to allow easier installation of perl
# modules, and their incorporation into the Gentoo Linux system.

inherit base

EXPORT_FUNCTIONS pkg_setup pkg_preinst pkg_postinst pkg_prerm pkg_postrm src_compile src_install src_test src_unpack

# 2005.04.28 mcummings
# Mounting problems with src_test functions has forced me to make the
# compilation of perl modules honor the FEATURES maketest flag rather than what
# is generally necessary. I've left a block to make sure we still need to set
# the SRC_TEST="do" flag on the suspicion that otherwise we will face 10 times
# as many bug reports as we have lately.
#
# 2004.05.10 rac
# block on makemaker versions earlier than that in the 5.8.2 core. in
# actuality, this should be handled in the perl ebuild, so every perl
# ebuild should block versions of MakeMaker older than the one it
# carries. in the meantime, since we have dumped support for MakeMaker
# <6.11 and the associated broken DESTDIR handling, block here to save
# people from sandbox trouble.
#
# 2004.05.25 rac
# for the same reasons, make the perl dep >=5.8.2 to get everybody
# with 5.8.0 and its 6.03 makemaker up to a version that can
# understand DESTDIR
#
# 2004.10.01 mcummings
# noticed a discrepancy in how we were sed fixing references to ${D}
#
# 2005.03.14 mcummings
# Updated eclass to include a specific function for dealing with perlocal.pods -
# this should avoid the conflicts we've been running into with the introduction
# of file collision features by giving us a single exportable function to deal
# with the pods. Modifications to the eclass provided by Yaakov S
# <yselkowitz@hotmail.com> in bug 83622
#
# <later the same day>
# The long awaited (by me) fix for automagically detecting and dealing
# with module-build dependancies. I've chosen not to make it a default dep since
# this adds overhead to people that might not otherwise need it, and instead
# modified the eclass to detect the existence of a Build.PL and behave
# accordingly. This will fix issues with g-cpan builds that needs module-build
# support, as well as get rid of the (annoying) style=builder vars. I know of
# only one module that needed to be hacked for this, Class-MethodMaker-2.05, but
# that module has a bad Build.PL to begin with. Ebuilds should continue to
# DEPEND on module-build<-version> as needed, but there should be no need for
# the style directive any more (especially since it isn't in the eclass
# anymore). Enjoy!
#
# 2005.07.18 mcummings
# Fix for proper handling of $mydoc - thanks to stkn for noticing we were
# bombing out there
#
# 2005.07.19 mcummings
# Providing an override var for the use of Module::Build. While it is being
# incorporated in more and more modules, not all module authors have working
# Build.PL's in place. The override is to allow for a fallback to the "classic"
# Makfile.PL - example is Class::MethodMaker, which provides a Build.PL that is
# severely broken.
#
# 2006.02.11 mcummings
# Per a conversation with solar, adding a change to the dep/rdep lines for
# minimal. Should fix bug 68367 and bug 83622, as well as other embedded builds
# that use perl components without providing perl
#
# 2006.06.13 mcummings
# I've reordered and extended the logic on when to invoke module-build versus
# MakeMaker. The problem that has arisen is that some modules provide a
# Makefile.PL that passes all arguments on to a Build.PL - including PREFIX,
# which causes module-build to build with a target of /usr/usr/
# (how broken is that?). Current logic is if there is a Build.PL and we aren't
# overriding, use it; otherwise use the Makefile.PL; otherwise return (maybe we
# want all the functionality of the perl-module eclass without needing to
# compile??).
#
# 2007.08.19 ian
# Added ${myconf} - bug #176818
#
# 2007.10.17 robbat2
# Added the 'MODULE_AUTHOR' variable. Set it before inheriting the eclass
# and it will set your HOMEPAGE and SRC_URI correctly for a CPAN package.
#
# 2008.09.30 robbat2
# MODULE_A enables variations other than .tar.gz easily. Also Use MY_P if set
# for MODULE_A and MY_PN in HOMEPAGE, as suggested by tove. 

[ -z "${SRC_URI}" -a -z "${MODULE_A}" ] && MODULE_A="${MY_P:-${P}}.tar.gz"
[ -z "${SRC_URI}" -a -n "${MODULE_AUTHOR}" ] && \
	SRC_URI="mirror://cpan/authors/id/${MODULE_AUTHOR:0:1}/${MODULE_AUTHOR:0:2}/${MODULE_AUTHOR}/${MODULE_SECTION}/${MODULE_A}"
[ -z "${HOMEPAGE}" ] && \
	HOMEPAGE="http://search.cpan.org/search?query=${MY_PN:-${PN}}&mode=dist"

SRC_PREP="no"
SRC_TEST="skip"
PREFER_BUILDPL="yes"

PERL_VERSION=""
SITE_ARCH=""
SITE_LIB=""
VENDOR_LIB=""
VENDOR_ARCH=""
ARCH_LIB=""
POD_DIR=""
BUILDER_VER=""
pm_echovar=""

perl-module_src_unpack() {
	if [[ -n ${PATCHES} ]]; then
		base_src_unpack unpack
		base_src_unpack autopatch
	else
		base_src_unpack unpack
	fi
}

perl-module_src_prep() {

	perlinfo

	export PERL_MM_USE_DEFAULT=1
	# Disable ExtUtils::AutoInstall from prompting
	export PERL_EXTUTILS_AUTOINSTALL="--skipdeps"


	SRC_PREP="yes"
	find ${S} -type d -name "\.svn" -exec /bin/rm -rf {} \; 2>/dev/null
	if [ "${PREFER_BUILDPL}" == "yes" ] && ( [ -f Build.PL ] || [ ${PN} == "module-build" ] ); then
		einfo "Using Module::Build"
		echo "$pm_echovar" | perl Build.PL ${myconf} --installdirs=vendor --destdir=${D} --libdoc= || die "Unable to build! (are you using USE=\"build\"?)"
	elif [ -f Makefile.PL ] && [ ! ${PN} == "module-build" ]; then
		einfo "Using ExtUtils::MakeMaker"
		echo "$pm_echovar" | perl Makefile.PL ${myconf} INSTALLMAN3DIR='none'\
		PREFIX=/usr INSTALLDIRS=vendor DESTDIR=${D} || die "Unable to build! (are you using USE=\"build\"?)"
	fi
	if [ ! -f Build.PL ] && [ ! -f Makefile.PL ]; then
		einfo "No Make or Build file detected..."
		return
	fi
}

perl-module_src_compile() {

	perlinfo
	[ "${SRC_PREP}" != "yes" ] && perl-module_src_prep
	if [ -f Makefile ]; then
		make ${mymake} || die "compilation failed"
	elif [ -f Build ]; then
		perl Build build || die "compilation failed"
	fi
	fixlocalpod

}

perl-module_src_test() {
	if [ "${SRC_TEST}" == "do" ]; then
		perlinfo
		if [ -f Makefile ]; then
			make test || die "test failed"
		elif [ -f Build ]; then
			perl Build  test || die "test failed"
		fi
	fi
}

perl-module_src_install() {

	perlinfo

	test -z ${mytargets} && mytargets="install"

	if [ -f Makefile ]; then
		make ${myinst} ${mytargets} || die
	elif [ -f Build ]; then
		perl ${S}/Build install
	fi


	einfo "Cleaning out stray man files"
	for FILE in `find ${D} -type f -name "*.3pm*"`; do
		rm -rf ${FILE}
	done
	find ${D}/usr/share/man -depth -type d 2>/dev/null | xargs -r rmdir 2>/dev/null

	fixlocalpod

	for FILE in `find ${D} -type f |grep -v '.so'`; do
		STAT=`file $FILE| grep -i " text"`
		if [ "${STAT}x" != "x" ]; then
			sed -i -e "s:${D}:/:g" ${FILE}
		fi
	done

	for doc in Change* MANIFEST* README* ${mydoc}; do
		[ -s "$doc" ] && dodoc $doc
	done
}


perl-module_pkg_setup() {

	perlinfo
}


perl-module_pkg_preinst() {

	perlinfo
}

perl-module_pkg_postinst() {

	einfo "Man pages are not installed for most modules now."
	einfo "Please use perldoc instead."
	updatepod
}

perl-module_pkg_prerm() {

	updatepod
}

perl-module_pkg_postrm() {

	updatepod
}

perlinfo() {

	local version
	eval `perl '-V:version'`
	PERL_VERSION=${version}

	local installsitearch
	eval `perl '-V:installsitearch'`
	SITE_ARCH=${installsitearch}

	local installsitelib
	eval `perl '-V:installsitelib'`
	SITE_LIB=${installsitelib}

	local installarchlib
	eval `perl '-V:installarchlib'`
	ARCH_LIB=${installarchlib}

	local installvendorlib
	eval `perl '-V:installvendorlib'`
	VENDOR_LIB=${installvendorlib}

	local installvendorarch
	eval `perl '-V:installvendorarch'`
	VENDOR_ARCH=${installvendorarch}

	if [ "${PREFER_BUILDPL}" == "yes" ]; then
		if [ ! -f ${S}/Makefile.PL ] || [ ${PN} == "module-build" ]; then
			if [ -f ${S}/Build.PL ]; then
				if [ ${PN} == "module-build" ]; then
					BUILDER_VER="1" # A bootstrapping if you will
				else
					BUILDER_VER=`perl -MModule::Build -e 'print "$Module::Build::VERSION;"' `
				fi
			fi
		fi
	fi

	if [ -f /usr/bin/perl ]
	then
		POD_DIR="/usr/share/perl/gentoo-pods/${version}"
	fi
}

fixlocalpod() {
	perlinfo

	if [ -f ${D}${ARCH_LIB}/perllocal.pod ];
	then
		rm -f ${D}/${ARCH_LIB}/perllocal.pod
	fi

	if [ -f ${D}${SITE_LIB}/perllocal.pod ];
	then
		rm -f ${D}/${SITE_LIB}/perllocal.pod
	fi

	if [ -f ${D}${VENDOR_LIB}/perllocal.pod ];
	then
		rm -f ${D}/${VENDOR_LIB}/perllocal.pod
	fi
}

updatepod() {
	perlinfo

	if [ -d "${POD_DIR}" ]
	then
		for FILE in `find ${POD_DIR} -type f -name "*.pod.arch"`; do
			cat ${FILE} >> ${ARCH_LIB}/perllocal.pod
			rm -f ${FILE}
		done
		for FILE in `find ${POD_DIR} -type f -name "*.pod.site"`; do
			cat ${FILE} >> ${SITE_LIB}/perllocal.pod
			rm -f ${FILE}
		done
		for FILE in `find ${POD_DIR} -type f -name "*.pod.vendor"`; do
			cat ${FILE} >> ${VENDOR_LIB}/perllocal.pod
			rm -f ${FILE}
		done
	fi
}
