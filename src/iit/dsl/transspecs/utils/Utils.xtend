package iit.dsl.transspecs.utils

import iit.dsl.transspecs.transSpecs.DesiredTransforms
import iit.dsl.transspecs.transSpecs.impl.TransSpecsFactoryImpl
import iit.dsl.coord.coordTransDsl.FramesList
import iit.dsl.coord.coordTransDsl.impl.CoordTransDslFactoryImpl
import java.util.HashSet

import iit.dsl.transspecs.transSpecs.TransformsList

import org.eclipse.xtext.EcoreUtil2
import iit.dsl.transspecs.transSpecs.FramePair
import iit.dsl.transspecs.transSpecs.TransSpecsFactory

class Utils {
    def public static areTheSame(FramePair p1, FramePair p2) {
        return ( p1.base.name.equals(p2.base.name) &&
                  p1.target.name.equals(p2.target.name)   )
    }

    def public static merge(DesiredTransforms m1, DesiredTransforms m2) {
        val retModel = factory.createDesiredTransforms()

        retModel.setFramesList(merge(m1.framesList, m2.framesList))
        retModel.setTransforms(merge(m1.transforms, m2.transforms))
        retModel.setName(m1.name + "_merged_with_" + m2.name)

        return retModel
    }

    def public static merge(FramesList f1, FramesList f2) {
        val retList = CoordTransDslFactoryImpl::init().createFramesList

        val set = new HashSet<String>()

        for(f : f1.items) {
            set.add(f.name)
        }

        val mergedList = retList.items
        for(f : f1.items) {
            mergedList.add(EcoreUtil2::copy(f))
        }

        for(f : f2.items) {
            if( ! set.contains(f.name)) {
                mergedList.add(EcoreUtil2::copy(f))
            }
        }

        return retList
    }

    def public static merge(TransformsList t1, TransformsList t2) {
        if(t1 == null) return t2
        if(t2 == null) return t1

        val retList = factory.createTransformsList
        val set = new HashSet<String>

        for(t : t1.specs) {
            set.add(myToString(t))
        }

        val mergedList = retList.specs
        var FramePair framePair
        for(t : t1.specs) {
            framePair = factory.createFramePair
            framePair.setBase(EcoreUtil2::copy(t.base))
            framePair.setTarget(EcoreUtil2::copy(t.target))
            mergedList.add(framePair)
        }

        for(t : t2.specs) {
            if( ! set.contains(myToString(t))) {
                framePair = factory.createFramePair
                framePair.setBase(EcoreUtil2::copy(t.base))
                framePair.setTarget(EcoreUtil2::copy(t.target))
                mergedList.add(framePair)
            }
        }

        return retList
    }

    def public static createModel(TransformsList transforms)
    {
        val frames = getFramesList(transforms)
        val model = factory.createDesiredTransforms()

        model.setFramesList(frames)
        model.setTransforms(transforms)
        return model
    }

    def public static FramesList getFramesList(TransformsList transforms)
    {
        val frames = CoordTransDslFactoryImpl::init().createFramesList
        val namesSet = new HashSet<String>()
        for(spec : transforms.specs) {
            if( ! namesSet.contains(spec.base.name) ) {
                namesSet.add(spec.base.name)
                frames.items.add( EcoreUtil2::copy(spec.base) )
            }
            if( ! namesSet.contains(spec.target.name) ) {
                namesSet.add(spec.target.name)
                frames.items.add( EcoreUtil2::copy(spec.target) )
            }
        }
        return frames
    }


    def private static myToString(FramePair fp) {
        return fp.base.name + "__" + fp.target.name
    }

    private static TransSpecsFactory factory = TransSpecsFactoryImpl::init()
}